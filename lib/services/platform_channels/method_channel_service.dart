import 'package:flutter/services.dart';

class MethodChannelService {
  final _channel = const MethodChannel('com.app.methods/actions');

  Future<void> start3rdMusicPlayer() =>
      _channel.invokeMethod('start3rdMusicPlayer');

  Future<bool?> show() {
    return _channel.invokeMethod<bool>('show');
  }

  Future<bool?> hide() {
    return _channel.invokeMethod<bool>('hide');
  }

  Future<bool?> isActive() {
    return _channel.invokeMethod<bool>('isActive');
  }

  Future<bool?> setTouchThru(bool isTouchThru) =>
      _channel.invokeMethod<bool>('setTouchThru', {'isTouchThru': isTouchThru});

  Future<bool?> toggleNotiListenerSettings() =>
      _channel.invokeMethod<bool>('toggleNotiListenerSettings');
}
