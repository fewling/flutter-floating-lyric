import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/search_lyric_status.dart';
import '../../models/lrc.dart';
import '../../models/media_state.dart';
import '../../models/overlay_window_config.dart';
import '../../models/to_overlay_msg_model.dart';
import '../../services/msg_channels/to_overlay_message_service.dart';

part 'msg_to_overlay_bloc.freezed.dart';
part 'msg_to_overlay_event.dart';
part 'msg_to_overlay_state.dart';

class MsgToOverlayBloc extends Bloc<MsgToOverlayEvent, MsgToOverlayState> {
  MsgToOverlayBloc({required ToOverlayMsgService toOverlayMsgService})
    : _toOverlayMsgService = toOverlayMsgService,
      super(const MsgToOverlayState()) {
    on<MsgToOverlayEvent>(
      (event, emit) => switch (event) {
        _WindowConfigsUpdated() => _onWindowConfigsUpdated(event, emit),
        _MediaStateUpdated() => _onMediaStateUpdated(event, emit),
        _LrcStateUpdated() => _onLrcUpdated(event, emit),
        _DeviceWidthUpdated() => _onDeviceWidthUpdated(event, emit),
      },
    );
  }

  final ToOverlayMsgService _toOverlayMsgService;

  void _onWindowConfigsUpdated(
    _WindowConfigsUpdated event,
    Emitter<MsgToOverlayState> emit,
  ) => _toOverlayMsgService.sendMsg(ToOverlayMsgConfig(event.config));

  void _onMediaStateUpdated(
    _MediaStateUpdated event,
    Emitter<MsgToOverlayState> emit,
  ) => _toOverlayMsgService.sendMsg(ToOverlayMsgMediaState(event.mediaState));

  void _onLrcUpdated(_LrcStateUpdated event, Emitter<MsgToOverlayState> emit) =>
      _toOverlayMsgService.sendMsg(
        ToOverlayMsgModel.lrcState(
          lrc: event.lrc,
          searchLyricStatus: event.searchStatus,
        ),
      );

  void _onDeviceWidthUpdated(
    _DeviceWidthUpdated event,
    Emitter<MsgToOverlayState> emit,
  ) => _toOverlayMsgService.sendMsg(ToOverlayMsgModel.deviceWidth(event.width));
}
