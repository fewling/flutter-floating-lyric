package com.example.floating_lyric.features.overlay_window


import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterTextureView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executor


class OverlayView(context: Context) {
    private var flutterView: FlutterView?
    private val flutterEngine: FlutterEngine?
    private var windowManager: WindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var uiHandler: Handler
    private var executor: Executor
    private var addedToWindow = false
    private var serviceContext: Context = context
    private var layoutParams: WindowManager.LayoutParams
    private var showing = false

    companion object {
        const val OVERLAY_ENGINE: String = "OVERLAY_ENGINE"
        private const val LAYOUT_FLAG =
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    }

    init {

        layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            LAYOUT_FLAG,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.CENTER
            y = 50
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES
            }
        }
        flutterEngine = FlutterEngineCache.getInstance().get(OVERLAY_ENGINE)
        flutterView = null
        setupLayoutMethodChannel(flutterEngine!!)
        this.uiHandler = Handler(Looper.getMainLooper())
        this.executor = ContextCompat.getMainExecutor(context)
    }

    private fun setupLayoutMethodChannel(flutterEngine: FlutterEngine) {
        val sizeChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.overlay.methods/layout")
        sizeChannel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "reportSize" -> {
                    val width = call.argument<Double>("width")
                    val height = call.argument<Double>("height")
                    if (width != null) {
                        layoutParams.width = width.toInt()
                    }
                    if (height != null) {
                        layoutParams.height = height.toInt()
                    }
                    updateViewWithLayoutParams()
                    result.success(true)
                }
            }
        }
    }


    fun addView() {
        Log.i("OverlayView Adding", "Added to window : $addedToWindow")
        Log.i("OverlayView Adding", "Flutter engine is there : ${flutterEngine != null}")
        if (addedToWindow) return
        if (flutterEngine == null) return
        try {
            val flutterSurfaceView = FlutterTextureView(serviceContext)
            flutterView = FlutterView(serviceContext, flutterSurfaceView)
            flutterView!!.attachToFlutterEngine(flutterEngine)
            flutterEngine.lifecycleChannel.appIsResumed()
            windowManager.addView(
                flutterView, layoutParams
            )
        } catch (e: Exception) {
            Log.e("OverlayView","Error adding overlay view")
        }
        addedToWindow = true
    }

    fun removeView() {
        Log.i("OverlayView Removing", "Added to window : $addedToWindow")
        Log.i("OverlayView Removing", "Flutter engine is there : ${flutterEngine != null}")
        if (!addedToWindow) return
        if (flutterEngine == null) return
        try {
            flutterEngine.lifecycleChannel.appIsResumed()
            flutterView!!.detachFromFlutterEngine()
            windowManager.removeView(flutterView)
            addedToWindow = false
        } catch (e: Exception) {
            Log.e("OverlayView","Error remove overlay view")
        }
    }

    private fun updateViewLayout(view: View?, params: WindowManager.LayoutParams?) {
        try {
            if (view != null && params != null && view.windowToken != null) windowManager.updateViewLayout(view, params)
        } catch (e: Exception) {
            Log.e("OverlayView","Error updating view layout")
        }
    }

    fun getLayoutParam(): WindowManager.LayoutParams {
        return layoutParams
    }

    fun updateLayoutParam(layoutParams: WindowManager.LayoutParams) {
        this.layoutParams = layoutParams
    }

    private fun updateViewWithLayoutParams() {
        updateViewLayout(flutterView, layoutParams)
    }

    fun show() {
        executor.execute {
            Log.i("OverlayView Show", "Showing now")
            flutterView?.visibility = View.VISIBLE
            showing = true
        }
    }

    fun hide() {
        executor.execute {
            Log.i("OverlayView Hide", "Hiding now")
            flutterView?.visibility = View.GONE
            showing = false
        }
    }
}