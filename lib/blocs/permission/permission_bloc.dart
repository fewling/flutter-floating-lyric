import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services/platform_channels/permission_channel_service.dart';

part 'permission_bloc.freezed.dart';
part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc({required PermissionChannelService permissionChannelService})
    : _permissionChannelService = permissionChannelService,
      super(const PermissionState()) {
    on<PermissionEvent>(
      (event, emit) => switch (event) {
        _Init() => _onInit(event, emit),
        _RequestNotificationListenerPermission() =>
          _onRequestNotificationListenerPermission(event, emit),
        _RequestSystemAlertWindowPermission() =>
          _onRequestSystemAlertWindowPermission(event, emit),
      },
    );
  }

  final PermissionChannelService _permissionChannelService;

  Future<void> _onInit(_Init event, Emitter<PermissionState> emit) async {
    final isListenerGranted = await _permissionChannelService
        .checkNotificationListenerPermission();
    final isWindowGranted = await _permissionChannelService
        .checkSystemAlertWindowPermission();

    emit(
      state.copyWith(
        isNotificationListenerGranted: isListenerGranted ?? false,
        isSystemAlertWindowGranted: isWindowGranted ?? false,
      ),
    );
  }

  void _onRequestNotificationListenerPermission(
    _RequestNotificationListenerPermission event,
    Emitter<PermissionState> emit,
  ) => _permissionChannelService.requestNotificationListenerPermission();

  void _onRequestSystemAlertWindowPermission(
    _RequestSystemAlertWindowPermission event,
    Emitter<PermissionState> emit,
  ) => _permissionChannelService.requestSystemAlertWindowPermission();
}
