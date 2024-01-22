import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _platform = MethodChannel('floating_lyric/method_channel');

final platformInvokerProvider = Provider((ref) => _PlatformInvoker(ref));

enum PlatformMethods {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,
  checkReadStoragePermission,

  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,
  requestReadStoragePermission,

  start3rdMusicPlayer,
}

class _PlatformInvoker {
  _PlatformInvoker(this.ref);

  ProviderRef<Object?> ref;

  Future<bool?> checkNotificationListenerPermission() => _platform
      .invokeMethod(PlatformMethods.checkNotificationListenerPermission.name);

  Future<bool?> requestNotificationListenerPermission() => _platform
      .invokeMethod(PlatformMethods.requestNotificationListenerPermission.name);

  Future<bool?> checkSystemAlertWindowPermission() => _platform
      .invokeMethod(PlatformMethods.checkSystemAlertWindowPermission.name);

  Future<bool?> requestSystemAlertWindowPermission() => _platform
      .invokeMethod(PlatformMethods.requestSystemAlertWindowPermission.name);

  Future<bool?> checkReadStoragePermission() =>
      _platform.invokeMethod(PlatformMethods.checkReadStoragePermission.name);

  Future<bool?> requestReadStoragePermission() =>
      _platform.invokeMethod(PlatformMethods.requestReadStoragePermission.name);

  Future<void> start3rdMusicPlayer() =>
      _platform.invokeMethod(PlatformMethods.start3rdMusicPlayer.name);
}
