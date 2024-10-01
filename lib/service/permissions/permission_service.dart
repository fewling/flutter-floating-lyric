import 'package:flutter/services.dart';

enum PermissionPlatformMethod {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,

  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,

  start3rdMusicPlayer,
}

class PermissionService {
  static const _channel = MethodChannel('floating_lyric/permission_method_channel');

  Future<bool?> checkNotificationListenerPermission() => _channel.invokeMethod(
        PermissionPlatformMethod.checkNotificationListenerPermission.name,
      );

  Future<bool?> requestNotificationListenerPermission() =>
      _channel.invokeMethod(PermissionPlatformMethod.requestNotificationListenerPermission.name);

  Future<bool?> checkSystemAlertWindowPermission() =>
      _channel.invokeMethod(PermissionPlatformMethod.checkSystemAlertWindowPermission.name);

  Future<bool?> requestSystemAlertWindowPermission() =>
      _channel.invokeMethod(PermissionPlatformMethod.requestSystemAlertWindowPermission.name);

  Future<void> start3rdMusicPlayer() => _channel.invokeMethod(PermissionPlatformMethod.start3rdMusicPlayer.name);
}
