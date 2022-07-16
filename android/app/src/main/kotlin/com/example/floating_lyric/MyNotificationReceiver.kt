package com.example.floating_lyric

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

import io.flutter.plugin.common.EventChannel.EventSink


class MyNotificationReceiver(private val eventSink: EventSink) : BroadcastReceiver() {
  override fun onReceive(context: Context?, intent: Intent) {
    /// Unpack intent contents
    val packageName: String = intent.getStringExtra(MyNotificationListener.PACKAGE_NAME).toString()
    val song: String = intent.getStringExtra(MyNotificationListener.SONG).toString()
    val singer: String = intent.getStringExtra(MyNotificationListener.SINGER).toString()
    val maxDuration: String = intent.getLongExtra(MyNotificationListener.MAX_DURATION, 0).toString()
    val currentDuration: String = intent.getLongExtra(MyNotificationListener.CURRENT_DURATION, 0).toString()


    /// Send data back via the Event Sink
    val data: HashMap<String, Any> = HashMap()
    data["package_name"] = packageName
    data["song"] = song
    data["singer"] = singer
    data["max_duration"] = maxDuration
    data["current_duration"] = currentDuration

    eventSink.success(data)
  }
}