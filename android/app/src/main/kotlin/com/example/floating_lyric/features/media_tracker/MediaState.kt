package com.example.floating_lyric.features.media_tracker

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class MediaState(
    var mediaPlayerName: String,
    var title: String,
    var artist: String,
    var album: String,
    var duration: Long,
    var position: Long,
    var isPlaying: Boolean,
) : Parcelable {

    fun toMap(): HashMap<String, Any> {
        val data: HashMap<String, Any> = HashMap()
        data["mediaPlayerName"] = mediaPlayerName
        data["title"] = title
        data["artist"] = artist
        data["album"] = album
        data["duration"] = duration.toDouble()
        data["position"] = position.toDouble()
        data["isPlaying"] = isPlaying

        return data
    }
}
