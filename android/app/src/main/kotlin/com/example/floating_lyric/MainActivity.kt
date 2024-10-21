package com.example.floating_lyric

import android.util.Log
import com.example.floating_lyric.features.media_tracker.MediaStateEventStreamHandler
import com.example.floating_lyric.features.overlay_window.OverlayView
import com.example.floating_lyric.features.permissions.PermissionMethodCallHandler
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val MEDIA_STATE_EVENT_CHANNEL = "Floating Lyric Media State Channel"
    }

    private lateinit var mediaStateEventChannel: EventChannel
    private lateinit var overlayStateEventChannel: EventChannel
    private lateinit var mediaStateEventStreamHandler: MediaStateEventStreamHandler


    private var overlayView: OverlayView? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val engineGroup = FlutterEngineGroup(this)

        val overlayEntryPoint = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(),
            "overlayView"
        )
        val overlayEngine = engineGroup.createAndRunEngine(this, overlayEntryPoint)
        FlutterEngineCache.getInstance().put("OVERLAY_ENGINE", overlayEngine)

        flutterEngine.plugins.add(PermissionMethodCallHandler())
//        flutterEngine.plugins.add(OverlayWindowMethodHandler())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.app.methods/actions")
            .also {
                it.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "show" -> {
                            if (overlayView == null) {
                                Log.i("Main", "Updating overlay view")
                                overlayView = OverlayView(this)
                            }
                            Log.i("Main", "Adding overlay view")
                            overlayView!!.addView()
                            Log.i("Main", "Showing overlay view")
                            overlayView!!.show()
                            result.success(true)
                        }

                        "hide" -> {
                            Log.i("Main", "Hiding overlay view")
                            overlayView?.hide()
                            Log.i("Main", "Removing overlay view")
                            overlayView?.removeView()
                            result.success(true)
                        }

                        "isActive" -> {
                            result.success(overlayView?.isActive() ?: false)
                        }

                        "setTouchThru" -> {
                            val isTouchThru = call.argument<Boolean>("isTouchThru")
                            overlayView?.updateWindowTouchThrough(isTouchThru ?: false)
                            result.success(true)
                        }
                    }
                }
            }


        mediaStateEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STATE_EVENT_CHANNEL)

        mediaStateEventStreamHandler = MediaStateEventStreamHandler(this)
        mediaStateEventChannel.setStreamHandler(mediaStateEventStreamHandler)
    }

    override fun onDestroy() {
        overlayView?.destroy()
        overlayView = null
        FlutterEngineCache.getInstance().remove("OVERLAY_ENGINE")
        mediaStateEventStreamHandler.unregisterReceiver()

        super.onDestroy()
    }
}
