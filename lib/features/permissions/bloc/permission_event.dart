part of 'permission_bloc.dart';

sealed class PermissionEvent {
  const PermissionEvent();
}

final class PermissionEventInitial extends PermissionEvent {
  const PermissionEventInitial();
}

final class NotificationListenerRequested extends PermissionEvent {
  const NotificationListenerRequested();
}

final class SystemAlertWindowRequested extends PermissionEvent {
  const SystemAlertWindowRequested();
}
