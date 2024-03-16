package com.example.floating_lyric.features.floating_window

import android.graphics.BlendMode
import android.graphics.BlendModeColorFilter
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.util.Log
import android.view.*
import android.widget.ImageButton
import android.widget.SeekBar
import android.widget.TextView
import com.example.floating_lyric.R
import java.text.SimpleDateFormat
import java.util.*

class FloatingWindow(
    private val inflater: LayoutInflater,
    private val windowManager: WindowManager,
    private val onWindowClose: () -> Unit,
    var state: WindowState,
) {

    companion object {
        private const val TAG = "FloatingWindow"
    }

    private val layoutParams: WindowManager.LayoutParams =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        } else {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        }.apply {
            gravity = Gravity.TOP or Gravity.START
            x = 0
            y = 0
        }

    private val alertView: View
    private val containerView: View

    private val floatingLyricTextView: TextView
    private val floatingTitleTextView: TextView
    private val floatingCloseImageButton: ImageButton
    private val floatingStartTimeTextView: TextView
    private val floatingMusicSeekBar: SeekBar
    private val floatingMaxTimeTextView: TextView

    private var showLyricOnly: Boolean = false

    init {
        Log.i(TAG, "Init")

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
                floatingTitleTextView.visibility = View.GONE
                floatingCloseImageButton.visibility = View.GONE

                if (!state.showProgressBar) {
                    floatingStartTimeTextView.visibility = View.GONE
                    floatingMusicSeekBar.visibility = View.GONE
                    floatingMaxTimeTextView.visibility = View.GONE
                }
            } else {
                floatingTitleTextView.visibility = View.VISIBLE
                floatingCloseImageButton.visibility = View.VISIBLE
                floatingStartTimeTextView.visibility = View.VISIBLE
                floatingMusicSeekBar.visibility = View.VISIBLE
                floatingMaxTimeTextView.visibility = View.VISIBLE
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
                (state.opacity / 100 * 255).toInt(),
                0,
                0,
                0
            ) // red color with alpha
        containerView.setBackgroundColor(color)

        floatingLyricTextView.textSize = state.fontSize.toFloat()
    }

    fun show() {
        Log.i(TAG, "show()")
        windowManager.addView(alertView, layoutParams)

        updateState(state.copy(isVisible = true))
    }

    fun hide() {
        Log.i(TAG, "hide()")
        try {
            windowManager.removeView(alertView)
            updateState(state.copy(isVisible = false))
            onWindowClose()

        } catch (e: Exception) {
            Log.e(TAG, e.toString())
        }
    }

    private fun showProgressBar() {
        floatingMusicSeekBar.visibility = View.VISIBLE
        floatingStartTimeTextView.visibility = View.VISIBLE
        floatingMaxTimeTextView.visibility = View.VISIBLE
    }

    private fun hideProgressBar() {
        floatingMusicSeekBar.visibility = View.GONE
        floatingStartTimeTextView.visibility = View.GONE
        floatingMaxTimeTextView.visibility = View.GONE
    }


    fun updateState(state: WindowState) {
        this.state = state
        updateTitle()
        updateProgressBar()

        if (showLyricOnly) {
            if (state.showProgressBar) {
                showProgressBar()
            } else {
                hideProgressBar()
            }
        }

        updateLyricLine()
        updateColor()
    }

    private fun updateTitle() {
        floatingTitleTextView.text = state.title
    }

    private fun updateProgressBar() {
        floatingMusicSeekBar.max = state.seekBarMax
        floatingMusicSeekBar.progress = state.seekBarProgress
        if (floatingMusicSeekBar.progress == state.seekBarMax)
            floatingMusicSeekBar.progress = 0

        val pattern = if (state.showMillis) "mm:ss.SS" else "mm:ss"
        val formatter = SimpleDateFormat(pattern)
        formatter.timeZone = TimeZone.getTimeZone("GMT")
        try {
            floatingStartTimeTextView.text = formatter.format(state.seekBarProgress)
            floatingMaxTimeTextView.text = formatter.format(state.seekBarMax)
        } catch (e: Exception) {
            Log.e(TAG, "format error: $e")
        }
    }


    private fun updateLyricLine() {
        floatingLyricTextView.text = state.lyricLine
        floatingLyricTextView.textSize = state.fontSize.toFloat()
    }

    private fun updateColor() {
        val color = Color.argb(
            state.a,
            state.r,
            state.g,
            state.b,
        )

        val bgColor = Color.argb((state.opacity / 100 * 255).toInt(), 0, 0, 0)
        containerView.setBackgroundColor(bgColor)
        floatingTitleTextView.setTextColor(color)
        floatingLyricTextView.setTextColor(color)
        floatingStartTimeTextView.setTextColor(color)
        floatingMaxTimeTextView.setTextColor(color)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            floatingCloseImageButton.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            floatingMusicSeekBar.thumb.colorFilter =
                BlendModeColorFilter(color, BlendMode.SRC_IN)
            floatingMusicSeekBar.progressDrawable.colorFilter =
                BlendModeColorFilter(color, BlendMode.SRC_IN)
        }
    }
}