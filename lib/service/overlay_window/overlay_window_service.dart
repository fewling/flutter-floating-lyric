import 'dart:async';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWindowService {
  OverlayWindowService({
    required this.devicePixelRatio,
  });

  final double devicePixelRatio;

  final _isActiveController = StreamController<bool>.broadcast();

  Stream<bool> get isActive => _isActiveController.stream;

  Future<void> toggle({required int height}) async {
    final isActive = await FlutterOverlayWindow.isActive();
    if (isActive) {
      await FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: (height * devicePixelRatio).ceil() + 2,
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
