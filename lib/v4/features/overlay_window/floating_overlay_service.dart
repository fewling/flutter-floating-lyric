import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'floating_overlay_event.dart';
import 'floating_overlay_state_types.dart';
import 'overlay_window_lyric_state.dart';
import 'overlay_window_style_state.dart';

part 'floating_overlay_service.g.dart';

@Riverpod(keepAlive: true)
FloatingOverlayService floatingOverlayService(FloatingOverlayServiceRef ref) {
  return FloatingOverlayService();
}

class FloatingOverlayService {
  Future<void> toggleFloatingOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 600,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
    );
  }

  void setLyricState(OverlayWindowLyricState state) {
    final json = jsonEncode(FloatingOverlayEvent(
      type: FloatingOverlayStateTypes.lyricState,
      lyricState: state,
    ).toJson());
    FlutterOverlayWindow.shareData(json);
  }

  void setStyleState(OverlayWindowStyleState state) {
    final json = jsonEncode(FloatingOverlayEvent(
      type: FloatingOverlayStateTypes.styleState,
      styleState: state,
    ).toJson());
    FlutterOverlayWindow.shareData(json);
  }
}
