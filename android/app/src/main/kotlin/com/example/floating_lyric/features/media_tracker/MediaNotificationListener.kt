package com.example.floating_lyric.features.media_tracker

import android.app.Notification
import android.app.NotificationChannel
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaMetadata
import android.media.session.MediaSession
import android.os.Build
import android.os.UserHandle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import android.media.session.MediaController
import android.media.session.PlaybackState
import android.os.Handler
import android.os.Looper
import com.example.floating_lyric.features.floating_window.WindowState
import com.example.floating_lyric.features.floating_window.WindowStateBroadcastReceiver
import java.util.*


class MediaNotificationListener : NotificationListenerService() {
    companion object {
        private const val TAG = "MediaNotiListener"
        private const val DEBUG_MAX_SECONDS = 5.0 // 5 seconds
        private const val HANDLER_PERIOD = 100L // 100ms
    }

    private val tokens = mutableMapOf<String, MediaSession.Token>()
    private lateinit var handler: Handler

    /// Used for debugging
    /// This variable is decremented every time the handler runs
    /// When it reaches 0, the handler will print the current media state
    private var debugLogTimerCountdown = 0.0

    override fun onDestroy() {
        super.onDestroy()
        Log.i(TAG, "onDestroy")

        handler.removeCallbacksAndMessages(null)
        handler.looper.quit()
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?, rankingMap: RankingMap?) {
        super.onNotificationPosted(sbn, rankingMap)
        Log.d(TAG, "onNotificationPosted: $sbn")
        Log.d(TAG, "onNotificationPosted: ${sbn?.notification?.extras.toString()}")

        if (sbn != null) {
            Log.d(TAG, "onNotificationPosted: ${sbn.packageName}")
            extractNotificationInfo(sbn)
        }
    }

    override fun onNotificationRemoved(
        sbn: StatusBarNotification?,
        rankingMap: RankingMap?,
        reason: Int
    ) {
        super.onNotificationRemoved(sbn, rankingMap, reason)
        Log.d(TAG, "onNotificationRemoved: ${sbn?.packageName}")
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.i(TAG, "onListenerConnected")

        for (sbn in activeNotifications) {
            extractNotificationInfo(sbn)
        }

        startPeriodicHandler()
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.i(TAG, "onListenerDisconnected")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val component = ComponentName(this, MediaNotificationListener::class.java)
            requestRebind(component)
        }
    }

    override fun onNotificationChannelModified(
        pkg: String?,
        user: UserHandle?,
        channel: NotificationChannel?,
        modificationType: Int
    ) {
        super.onNotificationChannelModified(pkg, user, channel, modificationType)
        Log.d(TAG, "onNotificationChannelModified: $pkg")
        Log.d(TAG, "onNotificationChannelModified: $user")
        Log.d(TAG, "onNotificationChannelModified: $channel")
        Log.d(TAG, "onNotificationChannelModified: $modificationType")
    }

    private fun extractNotificationInfo(sbn: StatusBarNotification) {
        val isThisApp = sbn.packageName == applicationContext.packageName
        if (isThisApp) return

        Log.i(TAG, "extractNotificationInfo: ${sbn.packageName}")

        val extras = sbn.notification.extras

        /// Check if the notification is a media notification
        val token = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            Log.i(TAG, "extractNotificationInfo: SDK >= TIRAMISU")
            extras.getParcelable(Notification.EXTRA_MEDIA_SESSION, MediaSession.Token::class.java)
        } else {
            Log.i(TAG, "extractNotificationInfo: SDK < TIRAMISU")
            extras.get(Notification.EXTRA_MEDIA_SESSION) as MediaSession.Token?
        }


        /// If the notification is not a media notification, return
        if (token == null) {
            Log.d(TAG, "token is null for ${sbn.packageName}")
            return
        }

        /// If the notification is a media notification, extract the information
        tokens[sbn.packageName] = token
        val controller = MediaController(applicationContext, token)
        val metadata = controller.metadata
        val duration = metadata?.getLong(MediaMetadata.METADATA_KEY_DURATION)
        val album = metadata?.getString((MediaMetadata.METADATA_KEY_ALBUM))
        val artist = metadata?.getString((MediaMetadata.METADATA_KEY_ARTIST))
        val title = metadata?.getString((MediaMetadata.METADATA_KEY_TITLE))

        Log.d(
            TAG, """
            extractNotificationInfo: 
            title: $title
            album: $album
            artist: $artist
            duration: $duration
        """.trimIndent()
        )
    }

    private fun startPeriodicHandler() {
        val pkgManager = applicationContext.packageManager

        handler = Handler(Looper.getMainLooper())

        val runnable = Runnable {
            debugLogTimerCountdown -= HANDLER_PERIOD.toDouble() / 1000

            val mediaStates = ArrayList<MediaState>()
            for (token in tokens.values) {
                val controller = MediaController(applicationContext, token)

                val metadata = controller.metadata
                val position = controller.playbackState?.position
                val duration = metadata?.getLong(MediaMetadata.METADATA_KEY_DURATION)
                val album = metadata?.getString((MediaMetadata.METADATA_KEY_ALBUM))
                val artist = metadata?.getString((MediaMetadata.METADATA_KEY_ARTIST))
                val title = metadata?.getString((MediaMetadata.METADATA_KEY_TITLE))
                val isPlaying = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    controller.playbackState?.isActive == true
                } else {
                    controller.playbackState?.state == PlaybackState.STATE_PLAYING
                }

                var appName = controller.packageName
                try {

                    val appInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        pkgManager.getApplicationInfo(
                            controller.packageName,
                            PackageManager.ApplicationInfoFlags.of(0)
                        )
                    } else {
                        pkgManager.getApplicationInfo(
                            controller.packageName,
                            PackageManager.GET_META_DATA
                        )
                    }
                    appName = pkgManager.getApplicationLabel(appInfo).toString()
                } catch (e: PackageManager.NameNotFoundException) {
                    if (debugLogTimerCountdown <= 0) {
                        e.printStackTrace()
                    }
                    appName = controller.packageName
                }

                if (debugLogTimerCountdown <= 0) {
                    Log.d(
                        TAG, """
                        extractNotificationInfo:
                        app: $appName
                        title: $title
                        album: $album
                        artist: $artist
                        duration: $duration
                        position: $position
                        isPlaying: $isPlaying
                    """.trimIndent()
                    )
                }


                val mediaState = MediaState(
                    mediaPlayerName = appName,
                    title = title ?: "unknown",
                    artist = artist ?: "unknown",
                    album = album ?: "unknown",
                    duration = duration ?: 0,
                    position = position ?: 0,
                    isPlaying = isPlaying,
                )
                mediaStates.add(mediaState)
            }

            val mediaStateIntent = Intent().apply {
                action = MediaStateBroadcastReceiver.ACTION_MEDIA_STATE_CHANGED
                putParcelableArrayListExtra(
                    MediaStateBroadcastReceiver.EXTRA_MEDIA_STATE,
                    mediaStates
                )
            }
            sendBroadcast(mediaStateIntent)

            // Repeat this runnable code block again another `HANDLER_PERIOD` milliseconds
            handler.postDelayed(this::startPeriodicHandler, HANDLER_PERIOD)


            if (debugLogTimerCountdown <= 0) {
                debugLogTimerCountdown = DEBUG_MAX_SECONDS
            }
        }

        // Start the initial runnable task
        handler.post(runnable)
    }
}














