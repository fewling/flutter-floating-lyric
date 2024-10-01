import 'dart:convert';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../models/overlay_settings_model.dart';

class ToOverlayMessageService {
  void sendSettings(OverlaySettingsModel settings) {
    final json = jsonDecode(jsonEncode(settings.toJson()));
    FlutterOverlayWindow.shareData(json);
  }

  Future<bool> isWindowActive() {
    return FlutterOverlayWindow.isActive();
  }

  Future<void> toggle() async {
    final isVisible = await FlutterOverlayWindow.isActive();
    if (isVisible) {
      await FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay();
    }
  }
}
