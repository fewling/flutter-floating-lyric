package com.example.floating_lyric

import android.content.ContentResolver
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity(), EventChannel.StreamHandler {
    private val TAG = "MainActivity"
    private val EVENT_CHANNEL = "Floating Lyric Channel"
    private lateinit var eventChannel: EventChannel

    private val METHOD_CHANNEL = "floating_lyric/method_channel"

    private val REQUEST_CODE_NOTIFICATION_LISTENER = 1

    private lateinit var _methodChannelResult: MethodChannel.Result

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            _methodChannelResult = result

            // This method is invoked on the main thread.
            if (call.method == "checkNotificationListenerPermission") {

                _methodChannelResult.success(isNotificationServiceRunning())

            } else if (call.method == "requestNotificationListenerPermission") {
                val isNotificationServiceRunning = isNotificationServiceRunning()
                if (!isNotificationServiceRunning) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                        startActivityForResult(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS), REQUEST_CODE_NOTIFICATION_LISTENER)
                    }
                }
            } else {
                _methodChannelResult.notImplemented()
            }
        }




        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode === REQUEST_CODE_NOTIFICATION_LISTENER) {
            _methodChannelResult.success(isNotificationServiceRunning())
        }
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

    private fun isNotificationServiceRunning(): Boolean {
        val contentResolver: ContentResolver = contentResolver
        val enabledNotificationListeners: String =
            Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        val packageName = packageName
        return enabledNotificationListeners.contains(packageName)
    }
}
