package com.example.floating_lyric.features.floating_window

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.floating_lyric.features.media_tracker.MediaState
import com.example.floating_lyric.features.media_tracker.MediaStateBroadcastReceiver
import io.flutter.plugin.common.EventChannel

class WindowStateBroadcastReceiver(private val eventSink: EventChannel.EventSink) :
    BroadcastReceiver() {

    companion object {
        const val ACTION_WINDOW_STATE_CHANGED =
            "com.example.floating_lyric.ACTION_WINDOW_STATE_CHANGED"
        const val EXTRA_WINDOW_STATE = "com.example.floating_lyric.EXTRA_WINDOW_STATE"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val windowState = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent?.getParcelableExtra(
                EXTRA_WINDOW_STATE,
                WindowState::class.java
            )
        } else {
            intent?.getParcelableExtra(EXTRA_WINDOW_STATE)
        }

        val data = windowState?.toMap()
        eventSink.success(data)
    }
}