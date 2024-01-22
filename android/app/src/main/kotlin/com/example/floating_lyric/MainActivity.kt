package com.example.floating_lyric

import com.example.floating_lyric.features.floating_window.WindowEventStreamHandler
import com.example.floating_lyric.features.floating_window.WindowMethodCallHandler
import com.example.floating_lyric.features.media_tracker.MediaStateEventStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {


    companion object {
        private const val MEDIA_STATE_EVENT_CHANNEL = "Floating Lyric Media State Channel"
        private const val WINDOW_STATE_EVENT_CHANNEL = "Floating Lyric Window State Channel"
    }

    private lateinit var mediaStateEventChannel: EventChannel
    private lateinit var windowStateEventChannel: EventChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.plugins.add(MyPlugin())
        flutterEngine.plugins.add(WindowMethodCallHandler())

        mediaStateEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STATE_EVENT_CHANNEL)
        mediaStateEventChannel.setStreamHandler(MediaStateEventStreamHandler(context))

        windowStateEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, WINDOW_STATE_EVENT_CHANNEL)
        windowStateEventChannel.setStreamHandler(WindowEventStreamHandler(context))
    }
}
