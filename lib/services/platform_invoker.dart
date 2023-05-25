import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_preference.dart';

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

  showFloatingWindow,
  closeFloatingWindow,
  updateFloatingWindow,
  checkFloatingWindow,

  updateWindowOpacity,
  updateWindowColor,
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

  Future<bool?> showFloatingWindow() {
    final pref = ref.read(preferenceProvider);
    final color = Color(pref.color);
    return _platform.invokeMethod(
      PlatformMethods.showFloatingWindow.name,
      {
        'opacity': pref.opacity,
        'r': color.red,
        'g': color.green,
        'b': color.blue,
        'a': color.alpha,
      },
    );
  }

  Future<bool?> closeFloatingWindow() =>
      _platform.invokeMethod(PlatformMethods.closeFloatingWindow.name);

  Future<bool?> updateFloatingWindow(String lyric) =>
      _platform.invokeMethod(PlatformMethods.updateFloatingWindow.name, lyric);

  Future<bool?> checkFloatingWindow() =>
      _platform.invokeMethod(PlatformMethods.checkFloatingWindow.name);

  Future<void> updateWindowOpacity() => _platform.invokeMethod(
        PlatformMethods.updateWindowOpacity.name,
        {'opacity': ref.read(preferenceProvider).opacity},
      );

  void updateWindowColor() {
    final color = Color(ref.read(preferenceProvider).color);
    _platform.invokeMapMethod(PlatformMethods.updateWindowColor.name,
        {'r': color.red, 'g': color.green, 'b': color.blue, 'a': color.alpha});
  }
}