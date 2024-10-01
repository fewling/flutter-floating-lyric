part of 'permission_bloc.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    @Default(false) bool isSystemAlertWindowGranted,
    @Default(false) bool isNotificationListenerGranted,
  }) = _PermissionState;
}
