import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/permissions/permission_service.dart';

part 'permission_bloc.freezed.dart';
part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({
    required PermissionService permissionService,
  })  : _permissionService = permissionService,
        super(const PermissionState()) {
    on<PermissionEvent>((event, emit) => switch (event) {
          PermissionEventInitial() => _onInitial(event, emit),
          NotificationListenerRequested() => _onNotificationListenerRequested(event, emit),
          SystemAlertWindowRequested() => _onSystemAlertWindowRequested(event, emit),
        });
  }

  final PermissionService _permissionService;

  Future<void> _onInitial(PermissionEventInitial event, Emitter<PermissionState> emit) async {
    final isListenerGranted = await _permissionService.checkNotificationListenerPermission();
    final isWindowGranted = await _permissionService.checkSystemAlertWindowPermission();

    emit(state.copyWith(
      isNotificationListenerGranted: isListenerGranted ?? false,
      isSystemAlertWindowGranted: isWindowGranted ?? false,
    ));
  }

  void _onNotificationListenerRequested(NotificationListenerRequested event, Emitter<PermissionState> emit) {}

  void _onSystemAlertWindowRequested(SystemAlertWindowRequested event, Emitter<PermissionState> emit) {}
}
