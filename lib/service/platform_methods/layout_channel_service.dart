import 'package:flutter/services.dart';

/// This class is mainly used in the Overlay side
class LayoutChannelService {
  static const String _channelName = 'com.overlay.methods/layout';
  static const MethodChannel _channel = MethodChannel(_channelName);

  Future<void> setLayout(double width, double height) async {
    return _channel.invokeMethod(
      'reportSize',
      {'width': width, 'height': height},
    );
  }

  Future<void> moveWindow(double dy) {
    return _channel.invokeMethod('moveWindow', {'dy': dy});
  }
}
