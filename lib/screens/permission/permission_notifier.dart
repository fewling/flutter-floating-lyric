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
    print('PermissionNotifier.build()');
    final systemAlertWindowGranted = await Permission.systemAlertWindow.isGranted;
    final notificationListenerGranted =
        await platform.invokeMethod(PlatformMethods.checkNotificationListenerPermission.name);

    print('systemAlertWindowGranted build: $systemAlertWindowGranted');

    return PermissionState(
      systemAlertWindowGranted: systemAlertWindowGranted,
      notificationListenerGranted: notificationListenerGranted as bool,
    );
  }

  bool allPermissionsGranted() => state.when(
        data: (value) {
          print('systemAlertWindowGranted: ${value.systemAlertWindowGranted}');
          return value.systemAlertWindowGranted && value.notificationListenerGranted;
        },
        error: (_, __) {
          print('error: $_');
          return false;
        },
        loading: () {
          print('loading');
          return false;
        },
      );

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
    final result = await platform
        .invokeMethod(PlatformMethods.checkNotificationListenerPermission.name) as bool;
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
