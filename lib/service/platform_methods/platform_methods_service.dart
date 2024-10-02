import 'package:flutter/services.dart';

enum _PlatformMethod {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,

  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,

  start3rdMusicPlayer,
}

class PlatformMethodsService {
  static const _channel = MethodChannel('floating_lyric/permission_method_channel');

  Future<bool?> checkNotificationListenerPermission() => _channel.invokeMethod(
        _PlatformMethod.checkNotificationListenerPermission.name,
      );

  Future<bool?> requestNotificationListenerPermission() =>
      _channel.invokeMethod(_PlatformMethod.requestNotificationListenerPermission.name);

  Future<bool?> checkSystemAlertWindowPermission() =>
      _channel.invokeMethod(_PlatformMethod.checkSystemAlertWindowPermission.name);

  Future<bool?> requestSystemAlertWindowPermission() =>
      _channel.invokeMethod(_PlatformMethod.requestSystemAlertWindowPermission.name);

  Future<void> start3rdMusicPlayer() => _channel.invokeMethod(_PlatformMethod.start3rdMusicPlayer.name);
}
