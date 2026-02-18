import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../configs/main_overlay/main_overlay_port.dart';
import '../../../models/overlay_settings_model.dart';
import '../../../models/to_overlay_msg_model.dart';
import '../../../service/event_channels/media_states/media_state.dart';
import '../../mixins/isolates_mixin.dart';

part 'msg_from_main_bloc.freezed.dart';
part 'msg_from_main_event.dart';
part 'msg_from_main_state.dart';

class MsgFromMainBloc extends Bloc<MsgFromMainEvent, MsgFromMainState>
    with IsolatesMixin {
  MsgFromMainBloc()
    : super(const MsgFromMainState(settings: null, mediaState: null)) {
    _receivePort = ReceivePort();

    on<MsgFromMainEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
      },
    );
  }

  late final ReceivePort _receivePort;

  @override
  Future<void> close() async {
    _receivePort.close();
    return super.close();
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<MsgFromMainState> emit,
  ) async {
    await registerPort(
      _receivePort.sendPort,
      MainOverlayPort.overlayPortName.key,
    );

    await emit.forEach(
      _receivePort.asBroadcastStream(),
      onData: (data) {
        final msg = ToOverlayMsgModel.fromJson(data as Map<String, dynamic>);

        switch (msg) {
          case ToOverlayMsgSettings():
            return state.copyWith(settings: msg.settings);

          case ToOverlayMsgMediaState():
            return state.copyWith(mediaState: msg.mediaState);
        }
      },
    );
  }
}
