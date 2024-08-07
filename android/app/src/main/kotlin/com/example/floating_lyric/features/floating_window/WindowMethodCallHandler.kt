package com.example.floating_lyric.features.floating_window

import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.LayoutInflater
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class WindowMethodCallHandler : FlutterPlugin, MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "WindowMethodHandler"
        private const val CHANNEL = "floating_lyric/window_method_channel"
    }

    private var mContext: Context? = null
    private lateinit var methodChannel: MethodChannel

    private var floatingWindow: FloatingWindow? = null

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
        floatingWindow?.hide()
        floatingWindow = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val inflater =
            mContext?.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val windowManager =
            mContext?.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        when (call.method) {
            "showFloatingWindow" -> {
                val arg = call.arguments as Map<*, *>
                Log.i(TAG, "showFloatingWindow: arg: $arg")

                val state = WindowState(
                    isVisible = true,
                    title = arg["title"] as String,
                    lyricLine = arg["lyricLine"] as String,
                    opacity = arg["opacity"] as Double,
                    r = arg["r"] as Int,
                    g = arg["g"] as Int,
                    b = arg["b"] as Int,
                    a = arg["a"] as Int,
                    seekBarMax = arg["seekBarMax"] as Int,
                    seekBarProgress = arg["seekBarProgress"] as Int,
                    showMillis = arg["showMillis"] as Boolean,
                    showProgressBar = arg["showProgressBar"] as Boolean,
                    fontSize = arg["fontSize"] as Int
                )

                if (floatingWindow == null) {
                    floatingWindow = FloatingWindow(
                        inflater,
                        windowManager,
                        state = state,
                        onLockBtnPressed = {
                            val intent = Intent().apply {
                                action = WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED
                                putExtra(
                                    WindowStateBroadcastReceiver.EXTRA_WINDOW_STATE,
                                    floatingWindow?.state?.copy(isLocked = false)
                                )
                            }
                            mContext?.sendBroadcast(intent)
                        },

                        onLockOpenBtnPressed = {
                            val intent = Intent().apply {
                                action = WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED
                                putExtra(
                                    WindowStateBroadcastReceiver.EXTRA_WINDOW_STATE,
                                    floatingWindow?.state?.copy(isLocked = true)
                                )
                            }
                            mContext?.sendBroadcast(intent)
                        },
                        onWindowClose = {
                            val intent = Intent().apply {
                                action = WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED
                                putExtra(
                                    WindowStateBroadcastReceiver.EXTRA_WINDOW_STATE,
                                    floatingWindow?.state
                                )
                            }
                            mContext?.sendBroadcast(intent)
                            floatingWindow = null
                        })
                }
                floatingWindow?.show()

                val intent = Intent().apply {
                    action = WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED
                    putExtra(WindowStateBroadcastReceiver.EXTRA_WINDOW_STATE, state)
                }
                mContext?.sendBroadcast(intent)
            }

            "closeFloatingWindow" -> {
                floatingWindow?.hide()
                val intent = Intent().apply {
                    action = WindowStateBroadcastReceiver.ACTION_WINDOW_STATE_CHANGED
                    putExtra(WindowStateBroadcastReceiver.EXTRA_WINDOW_STATE, floatingWindow?.state)
                }
                mContext?.sendBroadcast(intent)
            }

            "updateFloatingWindowState" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
//                val newState = floatingWindow!!.state.fromMap(arg)
                val newState = floatingWindow!!.state.copy(
                    title = arg["title"] as String,
                    lyricLine = arg["lyricLine"] as String,
                    seekBarMax = arg["seekBarMax"] as Int,
                    seekBarProgress = arg["seekBarProgress"] as Int,
                )
                floatingWindow!!.updateState(newState)
            }

            "updateWindowOpacity" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    opacity = arg["opacity"] as Double
                )
                floatingWindow!!.updateState(newState)
            }

            "updateWindowColor" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    r = arg["r"] as Int,
                    g = arg["g"] as Int,
                    b = arg["b"] as Int,
                    a = arg["a"] as Int,
                )
                floatingWindow!!.updateState(newState)
            }

            "updateMillisVisibility" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    showMillis = arg["showMillis"] as Boolean
                )
                floatingWindow!!.updateState(newState)
            }

            "updateProgressBarVisibility" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    showProgressBar = arg["showProgressBar"] as Boolean
                )
                floatingWindow!!.updateState(newState)
            }

            "updateFontSize" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    fontSize = arg["fontSize"] as Int
                )
                floatingWindow!!.updateState(newState)
            }

            "setWindowLock" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    isLocked = arg["isLocked"] as Boolean
                )
                floatingWindow!!.updateState(newState)
            }

            "setWindowTouchThrough" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    isTouchThrough = arg["isTouchThrough"] as Boolean
                )
                floatingWindow!!.updateState(newState)
            }

            "setWindowIgnoreTouch" -> {
                if (floatingWindow == null) return

                val arg = call.arguments as Map<*, *>
                val newState = floatingWindow!!.state.copy(
                    ignoreTouch = arg["ignoreTouch"] as Boolean
                )
                floatingWindow!!.updateState(newState)
            }

            else -> {
                result.notImplemented()
            }

        }
    }
}