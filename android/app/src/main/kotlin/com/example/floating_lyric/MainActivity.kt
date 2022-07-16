package com.example.floating_lyric

import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel


class MainActivity : FlutterActivity(), EventChannel.StreamHandler {
    private val TAG = "MainActivity"
    private val EVENT_CHANNEL = "event_channel"
    private lateinit var eventChannel: EventChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

//        Handler().postDelayed({
//            events?.success("Android")
//            // eventSink?.endOfStream()
//            // eventSink?.error("error code", "error message","error details")
//        }, 2000)

        /// Set up receiver
        val intentFilter = IntentFilter()
        intentFilter.addAction(MyNotificationListener.NOTIFICATION_INTENT)
        Log.i(TAG, "intentFilter: $intentFilter")

        val receiver = MyNotificationReceiver(events!!)
        registerReceiver(receiver, intentFilter)
        Log.i(TAG, "receiver: $receiver")


        /// Set up listener intent
        val listenerIntent = Intent(this@MainActivity, MyNotificationListener::class.java)
        Log.i(TAG, "listenerIntent: $listenerIntent")

        val service = startService(listenerIntent)
        Log.i(TAG, "service : $service")


        Log.i(TAG, "Started the notification tracking service.")
    }

    override fun onCancel(arguments: Any?) {
        Log.i("Android", "EventChannel onCancel called")
        eventChannel.setStreamHandler(null)
    }


}
