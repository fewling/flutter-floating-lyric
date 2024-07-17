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
  updateMillisVisibility,
  updateProgressBarVisibility,
  updateFontSize,
  setWindowLock,
  setWindowTouchThrough,
  setWindowIgnoreTouch,
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
      showMillis: pref.showMilliseconds,
      showProgressBar: pref.showProgressBar,
      fontSize: pref.fontSize,
    );

    ref.listen(
      lyricStateProvider,
      (prev, next) {
        final mediaState = next.mediaState;

        final msg = next.isSearchingOnline ? 'Searching lyric...' : next.currentLine ?? 'No lyric';

        _state = _state.copyWith(
          title: '${mediaState?.title} - ${mediaState?.artist}',
          lyricLine: msg,
          seekBarMax: mediaState?.duration.toInt() ?? 0,
          seekBarProgress: mediaState?.position.toInt() ?? 0,
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

    ref.listen(
      preferenceNotifierProvider.select((value) => value.showMilliseconds),
      (prev, next) {
        if (prev == next) return;

        _state = _state.copyWith(showMillis: next);
        updateMillisVisibility();
      },
    );

    ref.listen(
      preferenceNotifierProvider.select((value) => value.showProgressBar),
      (prev, next) {
        if (prev == next) return;

        _state = _state.copyWith(showProgressBar: next);
        updateProgressBarVisibility();
      },
    );

    ref.listen(
      preferenceNotifierProvider.select((value) => value.fontSize),
      (prev, next) {
        if (prev == next) return;

        _state = _state.copyWith(fontSize: next);
        updateFontSize();
      },
    );
  }

  Future<void> showFloatingWindow() => _channel.invokeMethod(
        WindowPlatformMethod.showFloatingWindow.name,
        _state.toJson(),
      );

  Future<void> closeFloatingWindow() => _channel.invokeMethod(WindowPlatformMethod.closeFloatingWindow.name);

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

  Future<void> updateMillisVisibility() => _channel.invokeMethod(
        WindowPlatformMethod.updateMillisVisibility.name,
        _state.toJson(),
      );

  Future<void> updateProgressBarVisibility() => _channel.invokeMethod(
        WindowPlatformMethod.updateProgressBarVisibility.name,
        _state.toJson(),
      );

  Future<void> updateFontSize() => _channel.invokeMethod(
        WindowPlatformMethod.updateFontSize.name,
        _state.toJson(),
      );

  void setWindowLock(bool value) {
    _state = _state.copyWith(isLocked: value);
    _channel.invokeMethod(
      WindowPlatformMethod.setWindowLock.name,
      _state.toJson(),
    );
  }

  void setWindowTouchThrough(bool value) {
    _state = _state.copyWith(isTouchThrough: value);
    _channel.invokeMethod(
      WindowPlatformMethod.setWindowTouchThrough.name,
      _state.toJson(),
    );
  }

  void setWindowIgnoreTouch(bool ignoreTouch) {
    _state = _state.copyWith(ignoreTouch: ignoreTouch);
    _channel.invokeMethod(
      WindowPlatformMethod.setWindowIgnoreTouch.name,
      _state.toJson(),
    );
  }
}
