import 'dart:async';
import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../features/overlay_window/bloc/overlay_window_bloc.dart';

class OverlayWindowService {
  final _isActiveController = StreamController<bool>.broadcast();

  Stream<bool> get isActive => _isActiveController.stream;

  void sendData(OverlayWindowState state) {
    FlutterOverlayWindow.shareData(
      jsonEncode(state.toJson()),
    );
  }

  Future<void> toggle({required int height}) async {
    final isActive = await FlutterOverlayWindow.isActive();
    if (isActive) {
      await FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: height,
        enableDrag: true,
        positionGravity: PositionGravity.auto,
      );
    }
    _notifyIsActive(!isActive);
  }

  void resizeWindow(int height) {
    FlutterOverlayWindow.resizeOverlay(
      WindowSize.matchParent,
      height,
      true,
    );
  }

  void _notifyIsActive(bool isActive) {
    _isActiveController.add(isActive);
  }
}
