import 'package:flutter/services.dart';

/// This class is mainly used in the Overlay side
class LayoutChannelService {
  LayoutChannelService() {
    _channel = const MethodChannel(_channelName);
  }

  static const _channelName = 'com.overlay.methods/layout';
  late final MethodChannel _channel;

  Future<void> setLayout(double width, double height) async {
    return _channel.invokeMethod('reportSize', {
      'width': width,
      'height': height,
    });
  }

  Future<bool?> toggleLock(bool isLocked) {
    return _channel.invokeMethod<bool>('toggleLock', {'isLocked': isLocked});
  }
}
