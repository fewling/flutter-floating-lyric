package com.example.floating_lyric.features.floating_window

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class WindowState(
    val isVisible: Boolean,
    val title: String = "",
    val lyricLine: String = "",
    val opacity: Double = 50.0,
    val r: Int = 255,
    val g: Int = 255,
    val b: Int = 255,
    val a: Int = 255,
    var seekBarMax: Int = 0,
    var seekBarProgress: Int = 0,
    var showMillis: Boolean = true,
    var showProgressBar: Boolean = true,
    var fontSize: Int = 24,

    ) : Parcelable {

    fun toMap(): HashMap<String, Any> {
        return hashMapOf(
            "isVisible" to isVisible,
            "title" to title,
            "lyricLine" to lyricLine,
            "opacity" to opacity,
            "r" to r,
            "g" to g,
            "b" to b,
            "a" to a,
            "seekBarMax" to seekBarMax,
            "seekBarProgress" to seekBarProgress,
            "showMillis" to showMillis,
            "showProgressBar" to showProgressBar,
            "fontSize" to fontSize,
        )
    }

    fun fromMap(map: Map<*, *>): WindowState {
        return WindowState(
            isVisible = map["isVisible"] as Boolean,
            title = map["title"] as String,
            lyricLine = map["lyricLine"] as String,
            opacity = map["opacity"] as Double,
            r = map["r"] as Int,
            g = map["g"] as Int,
            b = map["b"] as Int,
            a = map["a"] as Int,
            seekBarMax = map["seekBarMax"] as Int,
            seekBarProgress = map["seekBarProgress"] as Int,
            showMillis = map["showMillis"] as Boolean,
            showProgressBar = map["showProgressBar"] as Boolean,
            fontSize = map["fontSize"] as Int,
        )
    }
}
