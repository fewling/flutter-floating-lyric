package com.example.floating_lyric

import android.Manifest
import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.WindowManager
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


@RequiresApi(Build.VERSION_CODES.M)
class MyPlugin :
    FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {


    private var mContext: Context? = null
    private var mActivity: Activity? = null
    private lateinit var methodChannel: MethodChannel
    private lateinit var methodChannelResult: MethodChannel.Result

    private val TAG = "MyPlugin"
    private val CHANNEL = "floating_lyric/method_channel"
    private val REQUEST_CODE_NOTIFICATION_LISTENER = 1
    private val REQUEST_CODE_READ_STORAGE = 2

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "onAttachedToEngine")

        mContext = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "onDetachedFromEngine")
        mContext = null
        methodChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.i(TAG, "onAttachedToActivity")
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.i(TAG, "onDetachedFromActivityForConfigChanges")
        mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.i(TAG, "onReattachedToActivityForConfigChanges")
        mContext = binding.activity
    }

    override fun onDetachedFromActivity() {
        Log.i(TAG, "onDetachedFromActivity")
        mActivity = null
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//        Log.i(TAG, "onMethodCall: ${call.method}")
        methodChannelResult = result

        val inflater =
            mContext?.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val windowManager =
            mContext?.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        when (call.method) {
            "checkNotificationListenerPermission" -> {
                result.success(isNotificationListenerGranted())
            }

            "checkSystemAlertWindowPermission" -> {
                result.success(isSystemAlertWindowGranted())
            }

            "checkReadStoragePermission" -> {
                result.success(isReadStorageGranted())
            }

            "checkFloatingWindow" -> {
                result.success(CustomAlertWindow.getInstance(inflater, windowManager).isShowing)
            }

            "requestNotificationListenerPermission" -> {
                if (isNotificationListenerGranted()) {
                    methodChannelResult.success(true)
                    return
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    mActivity?.startActivityForResult(
                        Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS),
                        REQUEST_CODE_NOTIFICATION_LISTENER
                    )
                }
            }

            "requestSystemAlertWindowPermission" -> {
                if (isSystemAlertWindowGranted()) {
                    methodChannelResult.success((true))
                    return
                }

                val versionOK = Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                val canDrawOverlay = !Settings.canDrawOverlays(mContext)

                if (versionOK && canDrawOverlay) {
                    // https://stackoverflow.com/questions/41603332/onrequestpermissionsresult-not-being-triggered-for-overlay-permission
                    // ACTION_MANAGE_OVERLAY_PERMISSION does not return ActivityResult
                    val intent = Intent(
                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + mContext?.packageName)
                    )
                    mActivity?.startActivity(intent)
                }
            }

            "requestReadStoragePermission" -> {
                val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                    .setData(Uri.parse("package:" + mActivity?.packageName))
                mActivity?.startActivity(intent)
                Log.i(TAG, "onMethodCall: $mActivity")
            }

            "start3rdMusicPlayer" -> {
                val intent =
                    Intent.makeMainSelectorActivity(Intent.ACTION_MAIN, Intent.CATEGORY_APP_MUSIC)
                mActivity?.startActivity(intent)
            }

            "showFloatingWindow" -> {
//                Toast.makeText(mContext, "showFloatingWindow", Toast.LENGTH_SHORT).show()

                val arg = call.arguments as Map<String, Any>
                Log.i(TAG, "onMethodCall: arg: $arg")
                FromFlutterMessage.opacity = arg["opacity"] as Double
                FromFlutterMessage.color = arg["color"] as Long
//                FromFlutterMessage.backgroundColor = arg["backgroundColor"] as Long
                Log.i(TAG, "FromFlutterMessage.color : ${FromFlutterMessage.color}")
                CustomAlertWindow.getInstance(inflater, windowManager).show()
            }

            "closeFloatingWindow" -> {
                CustomAlertWindow.getInstance(inflater, windowManager).hide()
            }

            "updateFloatingWindow" -> {
                FromFlutterMessage.lyricLine = call.arguments as String
            }

            "test" -> {
                Toast.makeText(mContext, "Test Method", Toast.LENGTH_SHORT).show()
            }

            "updateWindowOpacity" -> {
                val arg = call.arguments as Map<String, Any>
                FromFlutterMessage.opacity = arg["opacity"] as Double
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.i(
            TAG, """onActivityResult
            requestCode: $requestCode
            resultCode: $resultCode
            Intent: $data            
        """.trimIndent()
        )

        when (requestCode) {
            REQUEST_CODE_NOTIFICATION_LISTENER -> {
                Log.i(TAG, " methodChannelResult.success(isNotificationListenerGranted())")
                methodChannelResult.success(isNotificationListenerGranted())
            }

            REQUEST_CODE_READ_STORAGE -> {
                Log.i(TAG, " methodChannelResult.success(isReadStorageGranted())")
                methodChannelResult.success(isReadStorageGranted())
            }
        }

        return true
    }

    private fun isNotificationListenerGranted(): Boolean {
        val contentResolver: ContentResolver? = mActivity?.contentResolver
        val enabledNotificationListeners: String =
            Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
        val packageName = mActivity?.packageName
        return enabledNotificationListeners.contains(packageName.toString())
    }

    private fun isSystemAlertWindowGranted(): Boolean = Settings.canDrawOverlays(mContext)

    private fun isReadStorageGranted(): Boolean {
        if (mContext == null) return false

        return ContextCompat.checkSelfPermission(
            mContext!!,
            Manifest.permission.READ_EXTERNAL_STORAGE
        ) == PackageManager.PERMISSION_GRANTED
    }

}