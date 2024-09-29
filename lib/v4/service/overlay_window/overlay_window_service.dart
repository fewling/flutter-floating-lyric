import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../features/overlay_window/bloc/overlay_window_bloc.dart';

class OverlayWindowService {
  void sendData(OverlayWindowState state) {
    FlutterOverlayWindow.shareData(
      jsonEncode(state.toJson()),
    );
  }

  Future<void> toggle() async {
    await FlutterOverlayWindow.showOverlay(
      height: 600,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
    );
  }
}
