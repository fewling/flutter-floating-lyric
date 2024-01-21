package com.example.floating_lyric

import android.content.IntentFilter
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.floating_lyric.features.media_tracker.MediaStateBroadcastReceiver
import com.example.floating_lyric.features.media_tracker.MediaStateEventStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {


    companion object {
        private const val TAG = "MainActivity"
        private const val MEDIA_STATE_EVENT_CHANNEL = "Floating Lyric Media State Channel"
        const val NOTIFICATION_INTENT = "my_notification_event"
    }

    private lateinit var mediaStateEventChannel: EventChannel

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.plugins.add(MyPlugin())

        mediaStateEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STATE_EVENT_CHANNEL)
        mediaStateEventChannel.setStreamHandler(MediaStateEventStreamHandler(context))
    }
}
