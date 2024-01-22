import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'method_channels/permission_method_invoker.dart';

part 'permission_provider.freezed.dart';

final _notificationListenerPermissionProvider = FutureProvider((ref) async {
  final invoker = ref.watch(permissionMethodInvokerProvider.notifier);
  return invoker.checkNotificationListenerPermission();
});

final _systemAlertWindowPermissionProvider = FutureProvider((ref) async {
  final invoker = ref.watch(permissionMethodInvokerProvider.notifier);
  return invoker.checkSystemAlertWindowPermission();
});

final permissionStateProvider =
    NotifierProvider<PermissionNotifier, PermissionState>(
        PermissionNotifier.new);

class PermissionNotifier extends Notifier<PermissionState> {
  @override
  PermissionState build() => _newState();

  void requestNotificationListener() {
    final invoker = ref.read(permissionMethodInvokerProvider.notifier);
    invoker.requestNotificationListenerPermission().then((value) =>
        state = state.copyWith(isNotificationListenerGranted: value ?? false));
  }

  void requestSystemAlertWindow() {
    // https://stackoverflow.com/questions/41603332/onrequestpermissionsresult-not-being-triggered-for-overlay-permission
    // ACTION_MANAGE_OVERLAY_PERMISSION does not return ActivityResult
    final invoker = ref.read(permissionMethodInvokerProvider.notifier);
    invoker.requestSystemAlertWindowPermission();
  }

  void refresh() {
    ref.invalidate(_notificationListenerPermissionProvider);
    ref.invalidate(_systemAlertWindowPermissionProvider);
    state = _newState();
  }

  PermissionState _newState() => PermissionState(
        isSystemAlertWindowGranted:
            ref.watch(_systemAlertWindowPermissionProvider).when(
                  data: (granted) => granted ?? false,
                  error: (_, __) => false,
                  loading: () => false,
                ),
        isNotificationListenerGranted:
            ref.watch(_notificationListenerPermissionProvider).when(
                  data: (granted) => granted ?? false,
                  error: (_, __) => false,
                  loading: () => false,
                ),
      );
}

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    required bool isSystemAlertWindowGranted,
    required bool isNotificationListenerGranted,
  }) = _PermissionState;
}
