import 'package:flutter/services.dart';

class WindowChannelService {
  final _channel = const MethodChannel('com.app.methods/actions');

  Future<bool?> show() {
    return _channel.invokeMethod<bool>('show');
  }

  Future<bool?> hide() {
    return _channel.invokeMethod<bool>('hide');
  }

  Future<bool?> isActive() {
    return _channel.invokeMethod<bool>('isActive');
  }

  Future<bool?> setTouchThru(bool isTouchThru) {
    return _channel.invokeMethod<bool>('setTouchThru', {
      'isTouchThru': isTouchThru,
    });
  }

  Future<bool?> toggleNotiListenerSettings() {
    return _channel.invokeMethod<bool>('toggleNotiListenerSettings');
  }
}
