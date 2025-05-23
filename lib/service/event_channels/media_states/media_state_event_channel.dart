// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/services.dart';

import 'media_state.dart';

const _channelName = 'Floating Lyric Media State Channel';
const _mediaStateChannel = EventChannel(_channelName);
final mediaStateStream = _mediaStateChannel.receiveBroadcastStream().map((
  event,
) {
  return (event as List<dynamic>).map((e) {
    final mediaPlayerName = e['mediaPlayerName'] as String;
    final title = e['title'] as String;
    final artist = e['artist'] as String;
    final album = e['album'] as String;
    final position = e['position'] as double;
    final duration = e['duration'] as double;
    final isPlaying = e['isPlaying'] as bool;

    return MediaState(
      mediaPlayerName: mediaPlayerName,
      title: title,
      artist: artist,
      album: album,
      position: position,
      duration: duration,
      isPlaying: isPlaying,
    );
  }).toList();
});
