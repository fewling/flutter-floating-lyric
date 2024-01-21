package com.example.floating_lyric.features.media_tracker

import android.content.Context
import android.content.IntentFilter
import android.util.Log
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.EventChannel.EventSink

class MediaStateEventStreamHandler(private val context: Context) : StreamHandler {
    companion object {
        private const val TAG = "MediaStateEventHandler"
    }

    private lateinit var mediaStateReceiver: MediaStateBroadcastReceiver

    override fun onListen(arguments: Any?, eventSink: EventSink?) {

        if (eventSink == null) {
            Log.e(TAG, "eventSink is null")
            return
        }

        val intentFilter = IntentFilter()
        intentFilter.addAction(MediaStateBroadcastReceiver.ACTION_MEDIA_STATE_CHANGED)

        mediaStateReceiver = MediaStateBroadcastReceiver(eventSink)
        context.registerReceiver(mediaStateReceiver, intentFilter)
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(mediaStateReceiver)
    }
}