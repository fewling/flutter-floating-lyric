import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_settings_model.dart';
import '../../../models/to_overlay_msg_model.dart';
import '../../../service/event_channels/media_states/media_state.dart';
import '../../../service/message_channels/to_overlay_message_service.dart';

part 'msg_to_overlay_bloc.freezed.dart';
part 'msg_to_overlay_event.dart';
part 'msg_to_overlay_state.dart';

class MsgToOverlayBloc extends Bloc<MsgToOverlayEvent, MsgToOverlayState> {
  MsgToOverlayBloc({required ToOverlayMsgService toOverlayMsgService})
    : _toOverlayMsgService = toOverlayMsgService,
      super(const MsgToOverlayState()) {
    on<MsgToOverlayEvent>(
      (event, emit) => switch (event) {
        _WindowSettingsUpdated() => _onWindowSettingsUpdated(event, emit),
        _MediaStateUpdated() => _onMediaStateUpdated(event, emit),
      },
    );
  }

  final ToOverlayMsgService _toOverlayMsgService;

  void _onWindowSettingsUpdated(
    _WindowSettingsUpdated event,
    Emitter<MsgToOverlayState> emit,
  ) => _toOverlayMsgService.sendWindowSettings(
    ToOverlayMsgSettings(event.settings),
  );

  void _onMediaStateUpdated(
    _MediaStateUpdated event,
    Emitter<MsgToOverlayState> emit,
  ) => _toOverlayMsgService.sendMediaState(
    ToOverlayMsgMediaState(event.mediaState),
  );
}
