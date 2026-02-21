package com.example.floating_lyric

import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {

    companion object {
        private const val MEDIA_STATE_EVENT_CHANNEL = "Floating Lyric Media State Channel"
    }

    private lateinit var mediaStateEventChannel: EventChannel
    private lateinit var overlayStateEventChannel: EventChannel
    private lateinit var mediaStateEventStreamHandler: MediaStateEventStreamHandler

    private lateinit var overlayEngine: FlutterEngine
    private var overlayView: OverlayView? = null

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val engineGroup = FlutterEngineGroup(this)

        val overlayEntryPoint = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(),
            "overlayView"
        )
        overlayEngine = engineGroup.createAndRunEngine(this, overlayEntryPoint)
        FlutterEngineCache.getInstance().put("OVERLAY_ENGINE", overlayEngine)

        flutterEngine.plugins.add(PermissionMethodCallHandler())
//        flutterEngine.plugins.add(OverlayWindowMethodHandler())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.app.methods/actions")
            .also {
                it.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "start3rdMusicPlayer" -> {
                            val intent =
                                Intent.makeMainSelectorActivity(Intent.ACTION_MAIN, Intent.CATEGORY_APP_MUSIC)
                            try {
                                startActivity(intent)
                            } catch (e: ActivityNotFoundException) {
                                // Handle the case where no music app is found on the device
                                Toast.makeText(this, "Could not found music app on device, please open one manually if exists.", Toast.LENGTH_LONG).show()
                            }
                        }

                        "show" -> {
                            if (overlayView == null) {
                                Log.i("Main", "Creating overlay view")
                                overlayView = OverlayView(this, overlayEngine)
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

                        "toggleNotiListenerSettings" -> {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                val componentName = ComponentName(
                                    this,
                                    "com.example.floating_lyric.features.media_tracker.MediaNotificationListener"
                                )

                                // Disable the notification listener service
                                packageManager.setComponentEnabledSetting(
                                    componentName,
                                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                                    PackageManager.DONT_KILL_APP
                                )

                                // enable the notification listener service after a delay
                                // to allow the system to process the disable request
                                CoroutineScope(Dispatchers.Default).launch {
                                    delay(1000)
                                    packageManager.setComponentEnabledSetting(
                                        componentName,
                                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                                        PackageManager.DONT_KILL_APP
                                    )
                                    result.success(true)
                                }
                            } else {
                                // For Android versions below TIRAMISU, show a dialog to inform the user
                                val builder = android.app.AlertDialog.Builder(this)
                                builder.setTitle("Manual Action - Notification Listener Service")
                                builder.setMessage("Please re-enable the Notification Listener Service in your device settings to continue.")
                                builder.setPositiveButton("Open Settings") { _, _ ->
                                    val intent =
                                        Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS")
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                    startActivity(intent)
                                    result.success(true)
                                }
                                builder.setNegativeButton("Cancel") { dialog, _ ->
                                    dialog.dismiss()
                                    result.success(true)
                                }
                                builder.create().show()
                            }
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
