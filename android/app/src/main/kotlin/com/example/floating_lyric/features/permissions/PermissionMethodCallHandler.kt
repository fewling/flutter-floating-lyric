package com.example.floating_lyric.features.permissions

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class PermissionMethodCallHandler :
    FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {

    companion object {
        private const val TAG = "PermissionMethodHandler"
    }    private val CHANNEL = "floating_lyric/permission_method_channel"


    private var mContext: Context? = null
    private var mActivity: Activity? = null
    private lateinit var methodChannel: MethodChannel
    private lateinit var methodChannelResult: MethodChannel.Result

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


        when (call.method) {
            "checkNotificationListenerPermission" -> {
                result.success(isNotificationListenerGranted())
            }

            "checkSystemAlertWindowPermission" -> {
                result.success(isSystemAlertWindowGranted())
            }

            "requestNotificationListenerPermission" -> {
                if (isNotificationListenerGranted()) {
                    methodChannelResult.success(true)
                    return
                }
                mActivity?.startActivityForResult(
                    Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS),
                    REQUEST_CODE_NOTIFICATION_LISTENER
                )
            }

            "requestSystemAlertWindowPermission" -> {
                if (isSystemAlertWindowGranted()) {
                    methodChannelResult.success((true))
                    return
                }

                val canDrawOverlay = !Settings.canDrawOverlays(mContext)
                if (canDrawOverlay) {
                    // https://stackoverflow.com/questions/41603332/onrequestpermissionsresult-not-being-triggered-for-overlay-permission
                    // ACTION_MANAGE_OVERLAY_PERMISSION does not return ActivityResult
                    val intent = Intent(
                        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + mContext?.packageName)
                    )
                    mActivity?.startActivity(intent)
                }
            }

            "start3rdMusicPlayer" -> {
                val intent =
                    Intent.makeMainSelectorActivity(Intent.ACTION_MAIN, Intent.CATEGORY_APP_MUSIC)
                try {
                    mActivity?.startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    // Handle the case where no music app is found on the device
                    Toast.makeText(mActivity, "Could not found music app on device, please open one manually if exists.", Toast.LENGTH_LONG).show()
                }
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