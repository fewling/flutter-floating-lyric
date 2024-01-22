import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../event_channels/window_states/window_state.dart';
import '../floating_lyrics/floating_lyric_notifier.dart';
import '../preferences/app_preference_notifier.dart';

part 'floating_window_method_invoker.g.dart';

enum WindowPlatformMethod {
  showFloatingWindow,
  closeFloatingWindow,
  updateFloatingWindowState,
  updateWindowOpacity,
  updateWindowColor,
  updateWindowProgress,
}

@Riverpod(keepAlive: true)
class FloatingWindowMethodInvoker extends _$FloatingWindowMethodInvoker {
  static const _channel = MethodChannel('floating_lyric/window_method_channel');

  var _state = const WindowState();

  @override
  void build() {
    final pref = ref.read(preferenceNotifierProvider);
    final color = Color(pref.color);
    _state = _state.copyWith(
      r: color.red,
      g: color.green,
      b: color.blue,
      a: color.alpha,
      opacity: pref.opacity,
    );

    ref.listen(
      lyricStateProvider,
      (prev, next) {
        _state = _state.copyWith(
          title: '${next.title} - ${next.artist}',
          lyricLine: next.currentLine ?? 'No lyric',
          seekBarMax: next.duration.toInt(),
          seekBarProgress: next.position.toInt(),
        );
        updateFloatingWindow();
      },
    );

    ref.listen(
      preferenceNotifierProvider.select((value) => value.color),
      (prev, next) {
        if (prev == next) return;

        final color = Color(next);
        _state = _state.copyWith(
          r: color.red,
          g: color.green,
          b: color.blue,
          a: color.alpha,
        );
        updateWindowColor();
      },
    );

    ref.listen(
      preferenceNotifierProvider.select((value) => value.opacity),
      (prev, next) {
        if (prev == next) return;

        _state = _state.copyWith(opacity: next);
        updateWindowOpacity();
      },
    );
  }

  Future<void> showFloatingWindow() => _channel.invokeMethod(
        WindowPlatformMethod.showFloatingWindow.name,
        _state.toJson(),
      );

  Future<void> closeFloatingWindow() =>
      _channel.invokeMethod(WindowPlatformMethod.closeFloatingWindow.name);

  Future<void> updateFloatingWindow() => _channel.invokeMethod(
        WindowPlatformMethod.updateFloatingWindowState.name,
        _state.toJson(),
      );

  Future<void> updateWindowOpacity() => _channel.invokeMethod(
        WindowPlatformMethod.updateWindowOpacity.name,
        _state.toJson(),
      );

  Future<void> updateWindowColor() => _channel.invokeMethod(
        WindowPlatformMethod.updateWindowColor.name,
        _state.toJson(),
      );
}
