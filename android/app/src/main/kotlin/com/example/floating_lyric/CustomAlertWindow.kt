package com.example.floating_lyric

import android.graphics.*
import android.os.Build
import android.util.Log
import android.view.*
import android.widget.ImageButton
import android.widget.SeekBar
import android.widget.TextView
import androidx.annotation.RequiresApi
import java.math.BigInteger.valueOf
import java.text.SimpleDateFormat
import java.util.*

class CustomAlertWindow(
    private val inflater: LayoutInflater,
    private val windowManager: WindowManager
) {
    companion object {
        private const val TAG = "CustomAlertWindow"
        private var instance: CustomAlertWindow? = null

        fun getInstance(inflater: LayoutInflater, windowManager: WindowManager): CustomAlertWindow {
            if (instance == null) {
                instance = CustomAlertWindow(inflater, windowManager)
            }
            return instance!!
        }
    }

    private lateinit var alertView: View
    private lateinit var containerView: View

    private lateinit var floatingLyricTextView: TextView
    private lateinit var floatingTitleTextView: TextView
    private lateinit var floatingCloseImageButton: ImageButton
    private lateinit var floatingStartTimeTextView: TextView
    private lateinit var floatingMusicSeekBar: SeekBar
    private lateinit var floatingMaxTimeTextView: TextView

    private var showLyricOnly: Boolean = false
    var isShowing: Boolean = false

    @RequiresApi(Build.VERSION_CODES.O)
    fun show() {
        Log.i(TAG, "show: isShowing: $isShowing")
        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )

        layoutParams.gravity = Gravity.TOP or Gravity.START
        layoutParams.x = 0
        layoutParams.y = 0

        alertView = inflater.inflate(R.layout.floating_lyric_service_layout, null)
        containerView = alertView.findViewById(R.id.notification_main_column_container)
        floatingLyricTextView = alertView.findViewById(R.id.floating_lyric_text_view)
        floatingTitleTextView = alertView.findViewById(R.id.floating_title_text_view)
        floatingCloseImageButton = alertView.findViewById(R.id.floating_image_button_close)
        floatingStartTimeTextView = alertView.findViewById(R.id.floating_start_time_text_view)
        floatingMaxTimeTextView = alertView.findViewById(R.id.floating_max_time_text_view)
        floatingMusicSeekBar = alertView.findViewById(R.id.floating_music_seekbar)
        floatingMusicSeekBar.setOnTouchListener { _, _ -> true }

        floatingCloseImageButton.setOnClickListener { hide() }
        alertView.setOnClickListener {
            showLyricOnly = !showLyricOnly
            /* Display/hide certain views in floating window: */
            if (showLyricOnly) {
                floatingTitleTextView.visibility = View.VISIBLE
                floatingCloseImageButton.visibility = View.VISIBLE
                floatingStartTimeTextView.visibility = View.VISIBLE
                floatingMusicSeekBar.visibility = View.VISIBLE
                floatingMaxTimeTextView.visibility = View.VISIBLE
            } else {
                floatingTitleTextView.visibility = View.INVISIBLE
                floatingCloseImageButton.visibility = View.GONE
                floatingStartTimeTextView.visibility = View.GONE
                floatingMusicSeekBar.visibility = View.GONE
                floatingMaxTimeTextView.visibility = View.GONE
            }
        }
        alertView.setOnTouchListener(object : View.OnTouchListener {
            var x = 0.0
            var y = 0.0
            var px = 0.0
            var py = 0.0
            override fun onTouch(v: View?, event: MotionEvent): Boolean {
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        x = layoutParams.x.toDouble()
                        y = layoutParams.y.toDouble()

                        // returns the original raw X
                        // coordinate of this event
                        px = event.rawX.toDouble()

                        // returns the original raw Y
                        // coordinate of this event
                        py = event.rawY.toDouble()
                    }
                    MotionEvent.ACTION_MOVE -> {
                        layoutParams.x = (x + event.rawX - px).toInt()
                        layoutParams.y = (y + event.rawY - py).toInt()

                        // updated parameter is applied to the WindowManager
                        windowManager.updateViewLayout(alertView, layoutParams)
                    }
                }
                return false
            }
        })

        val color =
            Color.argb(
                (FromFlutterMessage.opacity / 100 * 255).toInt(),
                0,
                0,
                0
            ) // red color with alpha
        containerView.setBackgroundColor(color)

        windowManager.addView(alertView, layoutParams)
        isShowing = true
        ToFlutterMessage.isShowing = true
    }

    fun hide() {
        Log.i(TAG, "hide: isShowing: $isShowing")
        try {
            windowManager.removeView(alertView)
            isShowing = false
            ToFlutterMessage.isShowing = false
        } catch (e: Exception) {
            Log.e(TAG, e.toString())
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun update(title: String?, artist: String?, duration: Long, position: Long, lyricLine: String) {
//        alertView.setBackgroundColor(Color.valueOf(FlutterMessage.backgroundColor).toArgb())
//        containerView.alpha = (FlutterMessage.opacity/100 * 255).toFloat()


        // Setting colors
        val color = valueOf(FromFlutterMessage.color).toInt()
        val bgColor = Color.argb((FromFlutterMessage.opacity / 100 * 255).toInt(), 0, 0, 0)
        containerView.setBackgroundColor(bgColor)
        floatingTitleTextView.setTextColor(color)
        floatingLyricTextView.setTextColor(color)
        floatingStartTimeTextView.setTextColor(color)
        floatingMaxTimeTextView.setTextColor(color)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            floatingCloseImageButton.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            floatingMusicSeekBar.thumb.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            floatingMusicSeekBar.progressDrawable.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
        }


        // Setting content
        floatingTitleTextView.text = "$title - $artist"
        floatingLyricTextView.text = lyricLine

        floatingMusicSeekBar.max = duration.toInt()
        floatingMusicSeekBar.progress = position.toInt()
        if (floatingMusicSeekBar.progress == duration.toInt())
            floatingMusicSeekBar.progress = 0

        val formatter = SimpleDateFormat("mm:ss.SS")
        formatter.timeZone = TimeZone.getTimeZone("GMT")
        try {
            floatingStartTimeTextView.text = formatter.format(position)
            floatingMaxTimeTextView.text = formatter.format(duration)
        } catch (e: Exception) {
            Log.e(TAG, "format error: $e")
        }
    }
}