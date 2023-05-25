package com.example.floating_lyric


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel

class MyBroadcastReceiver(private val eventSink: EventChannel.EventSink) : BroadcastReceiver() {

    // same key name as Flutter side
    companion object {
        val MEDIA_PLAYER_NAME = "mediaPlayerName"
        val TITLE = "title"
        val ARTIST = "artist"
        val DURATION = "duration"
        val POSITION = "position"
        val IS_PLAYING = "isPlaying"
        val IS_SHOWING = "isShowing"
    }

    override fun onReceive(context: Context?, intent: Intent) {
        /// Receive information from [MyNotificationListener]
        /// Send data to Flutter Side via the Event Sink
        val data: HashMap<String, Any> = HashMap()

//        data[MEDIA_PLAYER_NAME] = intent.getStringExtra(MEDIA_PLAYER_NAME).toString()
//        data[TITLE] = intent.getStringExtra(TITLE).toString()
//        data[ARTIST] = intent.getStringExtra(ARTIST).toString()
//        data[DURATION] = intent.getLongExtra(DURATION, 0).toDouble()
//        data[POSITION] = intent.getLongExtra(POSITION, 0).toDouble()
//        data[IS_PLAYING] = intent.getBooleanExtra(IS_PLAYING, false)
//        data[IS_SHOWING] = intent.getBooleanExtra(IS_SHOWING, false)

        data[MEDIA_PLAYER_NAME] = ToFlutterMessage.mediaPlayerName
        data[TITLE] = ToFlutterMessage.title
        data[ARTIST] = ToFlutterMessage.artist
        data[DURATION] = ToFlutterMessage.duration.toDouble()
        data[POSITION] = ToFlutterMessage.position.toDouble()
        data[IS_PLAYING] = ToFlutterMessage.isPlaying
        data[IS_SHOWING] = ToFlutterMessage.isShowing
        eventSink.success(data)
    }

}