import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../service/app_platform_channels.dart';

part 'permission_notifier.freezed.dart';

final permissionProvider =
    AsyncNotifierProvider<PermissionNotifier, PermissionState>(PermissionNotifier.new);

class PermissionNotifier extends AsyncNotifier<PermissionState> {
  @override
  Future<PermissionState> build() async {
    final systemAlertWindowGranted = await Permission.systemAlertWindow.isGranted;
    final notificationListenerGranted =
        await platform.invokeMethod(PlatformMethods.checkNotificationListenerPermission.name);

    return PermissionState(
      systemAlertWindowGranted: systemAlertWindowGranted,
      notificationListenerGranted: notificationListenerGranted,
    );
  }

  bool allPermissionsGranted() {
    final value = state.value;
    if (value == null) return false;

    return value.systemAlertWindowGranted && value.notificationListenerGranted;
  }

  void requestSystemAlertWindowPermission() {
    Permission.systemAlertWindow.request().then((permissionStatus) {
      if (state.value != null) {
        state = AsyncData(
          state.value!.copyWith(systemAlertWindowGranted: permissionStatus.isGranted),
        );
      }
    });
  }

  Future<bool> checkNotificationListenerPermission() async {
    bool result =
        await platform.invokeMethod(PlatformMethods.checkNotificationListenerPermission.name);
    if (state.value != null) {
      state = AsyncData(
        state.value!.copyWith(notificationListenerGranted: result),
      );
    }
    return result;
  }

  Future<void> requestNotificationListener() async {
    await platform.invokeMethod(PlatformMethods.requestNotificationListenerPermission.name);
    checkNotificationListenerPermission();
  }
}

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    required bool systemAlertWindowGranted,
    required bool notificationListenerGranted,
  }) = _PermissionState;
}
