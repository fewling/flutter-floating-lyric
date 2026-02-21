part of 'permission_bloc.dart';

@freezed
sealed class PermissionState with _$PermissionState {
  const factory PermissionState({
    @Default(false) bool isSystemAlertWindowGranted,
    @Default(false) bool isNotificationListenerGranted,
  }) = _PermissionState;
}
