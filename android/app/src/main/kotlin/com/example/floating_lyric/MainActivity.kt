package com.example.floating_lyric

import android.content.IntentFilter
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.example.floating_lyric.features.media_tracker.MediaStateBroadcastReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity(), EventChannel.StreamHandler {


    companion object {
        private const val TAG = "MainActivity"
        private const val EVENT_CHANNEL = "Floating Lyric Channel"
        const val NOTIFICATION_INTENT = "my_notification_event"
    }

    private lateinit var eventChannel: EventChannel
    private var receiver: MyBroadcastReceiver? = null
    private lateinit var mediaStateReceiver: MediaStateBroadcastReceiver

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.plugins.add(MyPlugin())

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {

        Log.i(TAG, "onListen:\n events: $eventSink")

        val intentFilter = IntentFilter()
        intentFilter.addAction(NOTIFICATION_INTENT)
        intentFilter.addAction(MediaStateBroadcastReceiver.ACTION_MEDIA_STATE_CHANGED)

        receiver = eventSink?.let { MyBroadcastReceiver(it) }!!
        mediaStateReceiver = MediaStateBroadcastReceiver(eventSink)

        context.registerReceiver(receiver, intentFilter)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (receiver != null) context.unregisterReceiver(receiver)

        context.unregisterReceiver(mediaStateReceiver)
    }

    override fun onCancel(arguments: Any?) {
        Log.i(TAG, "onCancel:\n arguments: $arguments")
    }
}
