package com.example.floating_lyric.features.media_tracker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.plugin.common.EventChannel

/// This class is used to receive the media state from the [MediaNotificationListener]
/// and send it to the [MediaStateStreamHandler] to be sent to the Flutter app.
class MediaStateBroadcastReceiver(private val eventSink: EventChannel.EventSink) : BroadcastReceiver(){
    companion object {
        const val ACTION_MEDIA_STATE_CHANGED = "com.example.floating_lyric.ACTION_MEDIA_STATE_CHANGED"
        const val EXTRA_MEDIA_STATE = "com.example.floating_lyric.EXTRA_MEDIA_STATE"
        const val TAG = "MediaStateBroadcast"
    }


    override fun onReceive(context: Context?, intent: Intent?) {
        val mediaStates: ArrayList<MediaState>? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent?.getParcelableArrayListExtra(EXTRA_MEDIA_STATE, MediaState::class.java)
        } else {
            intent?.getParcelableArrayListExtra(EXTRA_MEDIA_STATE)
        }

        val data = mediaStates?.map { it.toMap() }
        eventSink.success(data)


        // Also update floating window state
    }
}