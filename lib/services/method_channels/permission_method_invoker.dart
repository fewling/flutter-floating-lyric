import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_method_invoker.g.dart';

enum PermissionPlatformMethod {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,

  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,

  start3rdMusicPlayer,
}

@Riverpod(keepAlive: true)
class PermissionMethodInvoker extends _$PermissionMethodInvoker {
  static const _channel =
      MethodChannel('floating_lyric/permission_method_channel');

  @override
  void build() {}

  Future<bool?> checkNotificationListenerPermission() => _channel.invokeMethod(
        PermissionPlatformMethod.checkNotificationListenerPermission.name,
      );

  Future<bool?> requestNotificationListenerPermission() =>
      _channel.invokeMethod(
          PermissionPlatformMethod.requestNotificationListenerPermission.name);

  Future<bool?> checkSystemAlertWindowPermission() => _channel.invokeMethod(
      PermissionPlatformMethod.checkSystemAlertWindowPermission.name);

  Future<bool?> requestSystemAlertWindowPermission() => _channel.invokeMethod(
      PermissionPlatformMethod.requestSystemAlertWindowPermission.name);

  Future<void> start3rdMusicPlayer() =>
      _channel.invokeMethod(PermissionPlatformMethod.start3rdMusicPlayer.name);
}
