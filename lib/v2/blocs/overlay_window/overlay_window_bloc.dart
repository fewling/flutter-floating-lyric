import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/from_overlay_msg_model.dart';
import '../../../service/message_channels/to_main_message_service.dart';
import '../../services/platform_channels/layout_channel_service.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required ToMainMessageService toMainMessageService,
    required LayoutChannelService layoutChannelService,
  }) : _toMainMessageService = toMainMessageService,
       _layoutChannelService = layoutChannelService,
       super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _CloseRequested() => _onCloseRequested(event, emit),
        _WindowTapped() => _onWindowTapped(event, emit),
        _WindowResized() => _onWindowResized(event, emit),
        _LockToggled() => _onLockToggled(event, emit),
        _ScreenWidthRequested() => _onScreenWidthRequested(event, emit),
      },
    );
  }

  final ToMainMessageService _toMainMessageService;
  final LayoutChannelService _layoutChannelService;

  void _onStarted(_Started event, Emitter<OverlayWindowState> emit) {}

  void _onCloseRequested(
    _CloseRequested event,
    Emitter<OverlayWindowState> emit,
  ) {
    _toMainMessageService.sendMsg(
      const FromOverlayMsgModel(action: OverlayAction.close),
    );
  }

  void _onWindowTapped(_WindowTapped event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(isLyricOnly: !state.isLyricOnly));
  }

  void _onWindowResized(
    _WindowResized event,
    Emitter<OverlayWindowState> emit,
  ) {
    _layoutChannelService.setLayout(event.width, event.height);
  }

  Future<void> _onLockToggled(
    _LockToggled event,
    Emitter<OverlayWindowState> emit,
  ) async {
    final isSuccess = await _layoutChannelService.toggleLock(event.isLocked);

    if (isSuccess != null && isSuccess) {
      emit(state.copyWith(isLocked: event.isLocked));
    }
  }

  void _onScreenWidthRequested(
    _ScreenWidthRequested event,
    Emitter<OverlayWindowState> emit,
  ) {
    _toMainMessageService.sendMsg(
      const FromOverlayMsgModel(action: OverlayAction.measureScreenWidth),
    );
  }
}
