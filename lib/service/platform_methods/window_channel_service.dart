import 'package:flutter/services.dart';

class WindowChannelService {
  final _channel = const MethodChannel('com.app.methods/actions');

  void show() {
    _channel.invokeMethod('show');
  }

  void hide() {
    _channel.invokeMethod('hide');
  }
}
