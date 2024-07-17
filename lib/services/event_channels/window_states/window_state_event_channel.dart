import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

import 'window_state.dart';

const _channelName = 'Floating Lyric Window State Channel';
const windowStateChannel = EventChannel(_channelName);
final windowStateStream = windowStateChannel.receiveBroadcastStream().map(
  (event) {
    final windowState = event as Map<dynamic, dynamic>;
    final isVisible = windowState['isVisible'] as bool;
    final title = windowState['title'] as String;
    final lyricLine = windowState['lyricLine'] as String;
    final r = windowState['r'] as int;
    final g = windowState['g'] as int;
    final b = windowState['b'] as int;
    final a = windowState['a'] as int;
    final seekBarMax = windowState['seekBarMax'] as int;
    final seekBarProgress = windowState['seekBarProgress'] as int;
    final isLocked = windowState['isLocked'] as bool;
    final ignoreTouch = windowState['ignoreTouch'] as bool;

    Logger.d('Received window state.isLocked: $isLocked');

    return WindowState(
      isVisible: isVisible,
      title: title,
      lyricLine: lyricLine,
      r: r,
      g: g,
      b: b,
      a: a,
      seekBarMax: seekBarMax,
      seekBarProgress: seekBarProgress,
      isLocked: isLocked,
      ignoreTouch: ignoreTouch,
    );
  },
);
