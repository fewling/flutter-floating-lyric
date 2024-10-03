import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/from_overlay_msg_model.dart';
import '../../../service/message_channels/to_main_message_service.dart';
import '../../../service/platform_methods/layout_channel_service.dart';

part 'overlay_app_bloc.freezed.dart';
part 'overlay_app_bloc.g.dart';
part 'overlay_app_event.dart';
part 'overlay_app_state.dart';

class OverlayAppBloc extends Bloc<OverlayAppEvent, OverlayAppState> {
  OverlayAppBloc({
    required ToMainMessageService toMainMessageService,
    required LayoutChannelService layoutChannelService,
  })  : _toMainMessageService = toMainMessageService,
        _layoutChannelService = layoutChannelService,
        super(const OverlayAppState()) {
    on<OverlayAppEvent>(
      (event, emit) => switch (event) {
        OverlayAppStarted() => _onStarted(event, emit),
        CloseRequested() => _onCloseRequested(event, emit),
        WindowTouched() => _onWindowTouched(event, emit),
        WindowResized() => _onWindowResized(event, emit),
      },
    );
  }

  final ToMainMessageService _toMainMessageService;
  final LayoutChannelService _layoutChannelService;

  void _onStarted(OverlayAppStarted event, Emitter<OverlayAppState> emit) {}

  void _onCloseRequested(CloseRequested event, Emitter<OverlayAppState> emit) {
    _toMainMessageService.sendMsg(const FromOverlayMsgModel(
      action: OverlayAction.close,
    ));
  }

  void _onWindowTouched(WindowTouched event, Emitter<OverlayAppState> emit) {
    _toMainMessageService.sendMsg(const FromOverlayMsgModel(
      action: OverlayAction.windowTouched,
    ));
  }

  void _onWindowResized(WindowResized event, Emitter<OverlayAppState> emit) {
    _layoutChannelService.setLayout(event.width, event.height);
  }
}
