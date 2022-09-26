package com.example.floating_lyric


import android.app.Notification
import android.content.Intent
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession
import android.os.Handler
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log


class MyNotificationListener : NotificationListenerService() {

    private val TAG = "MyNotificationListener"

    companion object {
        const val NOTIFICATION_INTENT = "my_notification_event"
        var PACKAGE_NAME = "pkg_name"
        var SONG = "song"
        var SINGER = "singer"
        var MAX_DURATION = "max_duration"
        var CURRENT_DURATION = "current_duration"
    }


    private val handler = Handler()
    private var controller: MediaController? = null
    private var singer = ""
    private var song = ""

    /**
     * Listen to event occurs in Notification Section
     */
    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        // Log.i(TAG, "onNotificationPosted: ${sbn?.notification}")

        /* Check if notification event caused by MOOV: */
        if (sbn?.packageName.equals("com.now.moov")) {

            /* Check if the MOOV notification event involves media session: */
            // Log.i(
            //     TAG,
            //     "moov media session: ${sbn?.notification?.extras?.get(Notification.EXTRA_MEDIA_SESSION)}"
            // )
            if (sbn?.notification?.extras?.get(Notification.EXTRA_MEDIA_SESSION) == null)
                return

            /* Get the MediaSession token which belongs to MOOV: */
            // Log.i(
            //     TAG,
            //     "moov Token: ${sbn.notification.extras[Notification.EXTRA_MEDIA_SESSION] as MediaSession.Token}"
            // )
            val token: MediaSession.Token =
                sbn.notification.extras[Notification.EXTRA_MEDIA_SESSION] as MediaSession.Token


            /* Get the MediaController from the MOOV MediaSession token: */
            controller = MediaController(applicationContext, token)


            /* Get the music info from the MediaController */
            song = controller?.metadata?.description?.title.toString()
            singer = controller?.metadata?.description?.subtitle.toString()
//            val album = controller?.metadata?.description?.description.toString()

            Log.i(TAG, "metadata.description: ${controller?.metadata?.description}")
            Log.i(TAG, "title: ${controller?.metadata?.description?.title}")
            Log.i(TAG, "subtitle: ${controller?.metadata?.description?.subtitle}")
            Log.i(TAG, "description: ${controller?.metadata?.description?.description}")

            /* Sample results:
            I/MyNotificationListener(24170): metadata.description: 前世情人, 周杰倫, 周杰倫的床邊故事
            I/MyNotificationListener(24170): title: 前世情人
            I/MyNotificationListener(24170): subtitle: 周杰倫
            I/MyNotificationListener(24170): description: 周杰倫的床邊故事
            */

            startMoovRunnable()
        }

    }

    /**
     * Loop the lyric update mechanism every 100ms
     */
    private fun startMoovRunnable() {
        // Log.i(TAG, "startMoovRunnable")
        handler.removeCallbacks(moovRunnable)
        handler.postDelayed(moovRunnable, 100)
        // Log.i(TAG, "postDelayed moovRunnable")

    }

    /**
     * Tracks the music progress every 100ms and update the displaying lyric
     */
    private val moovRunnable = Runnable {

        // Log.i(TAG, "moov runnable")

        val maxDuration = controller?.metadata?.getLong(MediaMetadata.METADATA_KEY_DURATION)
//        val currentDuration = controller?.playbackState?.let { Date(it.position) }
        val currentDuration = controller?.playbackState?.position

        // Log.i(TAG, "MAX: $MAX_DURATION, CURRENT: $CURRENT_DURATION")

        // Pass data from one activity to another.
        val intent = Intent(NOTIFICATION_INTENT)
        // Log.i(TAG, "SINGER: $SINGER, SONG: $SONG, MAX: $MAX_DURATION, CURRENT: $CURRENT_DURATION")

        if (maxDuration != null && currentDuration != null) {


            intent.putExtra(PACKAGE_NAME, packageName)
            intent.putExtra(SINGER, singer)
            intent.putExtra(SONG, song)
            intent.putExtra(MAX_DURATION, maxDuration)
            intent.putExtra(CURRENT_DURATION, currentDuration)

            // Log.i(TAG, "sent broadcast")
        }
        sendBroadcast(intent)


        startMoovRunnable()
    }


}