package com.example.floating_lyric

import android.app.Notification
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import android.view.*
import androidx.annotation.RequiresApi
import com.example.floating_lyric.MainActivity.Companion.NOTIFICATION_INTENT
import com.example.floating_lyric.MyBroadcastReceiver.Companion.ARTIST
import com.example.floating_lyric.MyBroadcastReceiver.Companion.DURATION
import com.example.floating_lyric.MyBroadcastReceiver.Companion.IS_PLAYING
import com.example.floating_lyric.MyBroadcastReceiver.Companion.IS_SHOWING
import com.example.floating_lyric.MyBroadcastReceiver.Companion.MEDIA_PLAYER_NAME
import com.example.floating_lyric.MyBroadcastReceiver.Companion.POSITION
import com.example.floating_lyric.MyBroadcastReceiver.Companion.TITLE
import java.util.*

class MyNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "MyNotificationListener"
    }

    private var timer = Timer()
    private lateinit var inflater: LayoutInflater
    private lateinit var windowManager: WindowManager

    override fun onCreate() {
        super.onCreate()

        inflater = getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        checkAndUpdate(sbn)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onListenerConnected() {
        super.onListenerConnected()
        val notifications = activeNotifications
        for (notification in notifications) {
            checkAndUpdate(notification)
        }
    }

    private fun checkAndUpdate(sbn: StatusBarNotification?) {
        if (!sbn?.packageName.equals("com.example.floating_lyric")) {
            val sbnExtras = sbn?.notification?.extras
            if (sbnExtras?.get(Notification.EXTRA_MEDIA_SESSION) != null) {

                val token: MediaSession.Token =
                    sbnExtras[Notification.EXTRA_MEDIA_SESSION] as MediaSession.Token

                val controller = MediaController(applicationContext, token)
                restartTimer(controller)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.i(TAG, "onDestroy")
        timer.cancel()
    }

    private fun restartTimer(controller: MediaController) {

        val packageName = controller.packageName
        val metadata = controller.metadata
        val duration = metadata?.getLong(MediaMetadata.METADATA_KEY_DURATION)
        val album = metadata?.getString((MediaMetadata.METADATA_KEY_ALBUM))
        val artist = metadata?.getString((MediaMetadata.METADATA_KEY_ARTIST))
        val title = metadata?.getString((MediaMetadata.METADATA_KEY_TITLE))

//        Log.i(
//            TAG, """
//            title: $title
//            album: $album
//            artist: $artist
//            duration: $duration
//        """.trimIndent()
//        )

        timer.cancel()
        timer = Timer()
        timer.run {
            scheduleAtFixedRate(object : TimerTask() {

                @RequiresApi(Build.VERSION_CODES.O)
                override fun run() {
                    // Pass data from one activity to another.
                    val position = controller.playbackState?.position

                    if (duration != null && position != null) {
                        val intent = Intent(NOTIFICATION_INTENT)

                        ToFlutterMessage.mediaPlayerName = packageName
                        ToFlutterMessage.title = title.toString()
                        ToFlutterMessage.artist = artist.toString()
                        ToFlutterMessage.duration = duration
                        ToFlutterMessage.position = position



                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            ToFlutterMessage.isPlaying = controller.playbackState?.isActive == true
                        }

                        ToFlutterMessage.isShowing =
                            CustomAlertWindow.getInstance(inflater, windowManager).isShowing
                        if (ToFlutterMessage.isShowing) {
                            Handler(Looper.getMainLooper()).post {
                                CustomAlertWindow.getInstance(inflater, windowManager)
                                    .update(title, artist, duration, position, FromFlutterMessage.lyricLine)
                            }
                        }

                        sendBroadcast(intent)
                    }
                }
            }, 0, 100)
        }
    }

}