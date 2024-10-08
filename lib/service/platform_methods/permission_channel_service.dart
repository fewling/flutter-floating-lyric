import 'package:flutter/services.dart';

enum _PermissionMethod {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,

  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,

  start3rdMusicPlayer,
}

class PermissionChannelService {
  static const _channel = MethodChannel('floating_lyric/permission_method_channel');

  Future<bool?> checkNotificationListenerPermission() => _channel.invokeMethod(
        _PermissionMethod.checkNotificationListenerPermission.name,
      );

  Future<bool?> requestNotificationListenerPermission() =>
      _channel.invokeMethod(_PermissionMethod.requestNotificationListenerPermission.name);

  Future<bool?> checkSystemAlertWindowPermission() =>
      _channel.invokeMethod(_PermissionMethod.checkSystemAlertWindowPermission.name);

  Future<bool?> requestSystemAlertWindowPermission() =>
      _channel.invokeMethod(_PermissionMethod.requestSystemAlertWindowPermission.name);

  Future<void> start3rdMusicPlayer() => _channel.invokeMethod(_PermissionMethod.start3rdMusicPlayer.name);
}
