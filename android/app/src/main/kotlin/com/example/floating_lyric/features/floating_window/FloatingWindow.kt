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
    private val onLockBtnPressed: () -> Unit,
    private val onLockOpenBtnPressed: () -> Unit,
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

    private val lyricTextView: TextView
    private val titleTextView: TextView
    private val closeImageButton: ImageButton
    private val lockImageButton: ImageButton
    private val lockOpenImageButton: ImageButton
    private val startTimeTextView: TextView
    private val musicSeekBar: SeekBar
    private val maxTimeTextView: TextView

    private var showLyricOnly: Boolean = false

    init {
        Log.i(TAG, "Init")

        alertView = inflater.inflate(R.layout.floating_lyric_service_layout, null)
        containerView = alertView.findViewById(R.id.notification_main_column_container)
        lyricTextView = alertView.findViewById(R.id.floating_lyric_text_view)
        titleTextView = alertView.findViewById(R.id.floating_title_text_view)
        closeImageButton = alertView.findViewById(R.id.floating_image_button_close)
        lockImageButton = alertView.findViewById(R.id.floating_image_button_lock)
        lockOpenImageButton = alertView.findViewById(R.id.floating_image_button_lock_open)
        startTimeTextView = alertView.findViewById(R.id.floating_start_time_text_view)
        maxTimeTextView = alertView.findViewById(R.id.floating_max_time_text_view)
        musicSeekBar = alertView.findViewById(R.id.floating_music_seekbar)
        musicSeekBar.setOnTouchListener { _, _ -> true }

        closeImageButton.setOnClickListener { hide() }
        lockImageButton.setOnClickListener {
            onLockBtnPressed()
        }
        lockOpenImageButton.setOnClickListener {
            onLockOpenBtnPressed()
        }
        alertView.setOnClickListener {
            showLyricOnly = !showLyricOnly
            /* Display/hide certain views in floating window: */
            if (showLyricOnly) {
                titleTextView.visibility = View.GONE
                closeImageButton.visibility = View.GONE
                lockImageButton.visibility = View.GONE
                lockOpenImageButton.visibility = View.GONE

                if (this.state.showProgressBar.not()) {
                    startTimeTextView.visibility = View.GONE
                    musicSeekBar.visibility = View.GONE
                    maxTimeTextView.visibility = View.GONE
                }
            } else {
                titleTextView.visibility = View.VISIBLE
                closeImageButton.visibility = View.VISIBLE
                lockImageButton.visibility = View.VISIBLE
                startTimeTextView.visibility = View.VISIBLE
                musicSeekBar.visibility = View.VISIBLE
                maxTimeTextView.visibility = View.VISIBLE

                if (this.state.isLocked) {
                    lockImageButton.visibility = View.VISIBLE
                    lockOpenImageButton.visibility = View.GONE
                } else {
                    lockImageButton.visibility = View.GONE
                    lockOpenImageButton.visibility = View.VISIBLE
                }
            }
        }
        alertView.setOnTouchListener(object : View.OnTouchListener {
            var x = 0.0
            var y = 0.0
            var px = 0.0
            var py = 0.0
            override fun onTouch(v: View?, event: MotionEvent): Boolean {
                
                if (state.isLocked) return false

                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        x = layoutParams.x.toDouble()
                        y = layoutParams.y.toDouble()

                        // returns the original raw X & Y coordinates of this event
                        px = event.rawX.toDouble()
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

        val color = Color.argb((state.opacity / 100 * 255).toInt(), 0, 0, 0)
        containerView.setBackgroundColor(color)

        lyricTextView.textSize = state.fontSize.toFloat()
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
        musicSeekBar.visibility = View.VISIBLE
        startTimeTextView.visibility = View.VISIBLE
        maxTimeTextView.visibility = View.VISIBLE
    }

    private fun hideProgressBar() {
        musicSeekBar.visibility = View.GONE
        startTimeTextView.visibility = View.GONE
        maxTimeTextView.visibility = View.GONE
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
        updateWindowLock()
    }

    private fun updateTitle() {
        titleTextView.text = state.title
    }

    private fun updateProgressBar() {
        musicSeekBar.max = state.seekBarMax
        musicSeekBar.progress = state.seekBarProgress
        if (musicSeekBar.progress == state.seekBarMax)
            musicSeekBar.progress = 0

        val pattern = if (state.showMillis) "mm:ss.SS" else "mm:ss"
        val formatter = SimpleDateFormat(pattern)
        formatter.timeZone = TimeZone.getTimeZone("GMT")
        try {
            startTimeTextView.text = formatter.format(state.seekBarProgress)
            maxTimeTextView.text = formatter.format(state.seekBarMax)
        } catch (e: Exception) {
            Log.e(TAG, "format error: $e")
        }
    }


    private fun updateLyricLine() {
        lyricTextView.text = state.lyricLine
        lyricTextView.textSize = state.fontSize.toFloat()
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
        titleTextView.setTextColor(color)
        lyricTextView.setTextColor(color)
        startTimeTextView.setTextColor(color)
        maxTimeTextView.setTextColor(color)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            closeImageButton.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            lockImageButton.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            lockOpenImageButton.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            musicSeekBar.thumb.colorFilter = BlendModeColorFilter(color, BlendMode.SRC_IN)
            musicSeekBar.progressDrawable.colorFilter =
                BlendModeColorFilter(color, BlendMode.SRC_IN)
        }
    }

    private fun updateWindowLock() {
        if (showLyricOnly) return

        if (state.isLocked) {
            lockImageButton.visibility = View.VISIBLE
            lockOpenImageButton.visibility = View.GONE
        } else {
            lockImageButton.visibility = View.GONE
            lockOpenImageButton.visibility = View.VISIBLE
        }
    }
}