import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../features/overlay_window/bloc/overlay_window_bloc.dart';

class OverlayWindowService {
  Future<void> toggleFloatingOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 600,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
    );
  }

  void setOverlayWindowState(OverlayWindowState state) {
    final json = jsonDecode(jsonEncode(state.toJson()));

    FlutterOverlayWindow.shareData(json);
  }
}
