part of 'permission_bloc.dart';

@freezed
sealed class PermissionEvent with _$PermissionEvent {
  const factory PermissionEvent.init() = _Init;
  const factory PermissionEvent.requestNotificationListenerPermission() =
      _RequestNotificationListenerPermission;
  const factory PermissionEvent.requestSystemAlertWindowPermission() =
      _RequestSystemAlertWindowPermission;
}
