package com.example.floating_lyric.features.floating_window

import android.content.Context
import android.content.IntentFilter
import android.util.Log
import io.flutter.plugin.common.EventChannel

class WindowEventStreamHandler(private val context: Context) : EventChannel.StreamHandler {

    companion object {
        private const val TAG = "WindowEventStream"
    }

    private lateinit var windowStateReceiver: WindowStateBroadcastReceiver

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        if (eventSink == null) {
            Log.e(TAG, "eventSink is null")
            return
        }

        val intentFilter = IntentFilter()
        intentFilter.addAction(WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED)

        windowStateReceiver = WindowStateBroadcastReceiver(eventSink)
        context.registerReceiver(windowStateReceiver, intentFilter)
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(windowStateReceiver)
    }
}