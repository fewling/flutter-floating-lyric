import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../configs/main_overlay/main_overlay_port.dart';
import '../../../../models/overlay_settings_model.dart';
import '../../../../models/to_overlay_msg_model.dart';
import '../../../../v2/mixins/isolates_mixin.dart';

part 'message_from_main_receiver_bloc.freezed.dart';
part 'message_from_main_receiver_bloc.g.dart';
part 'message_from_main_receiver_event.dart';
part 'message_from_main_receiver_state.dart';

class MessageFromMainReceiverBloc
    extends Bloc<MessageFromMainReceiverEvent, MessageFromMainReceiverState>
    with IsolatesMixin {
  MessageFromMainReceiverBloc() : super(const MessageFromMainReceiverState()) {
    _receivePort = ReceivePort();

    on<MessageFromMainReceiverEvent>(
      (event, emit) => switch (event) {
        MessageFromMainReceiverStarted() => _onStarted(event, emit),
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
    MessageFromMainReceiverStarted event,
    Emitter<MessageFromMainReceiverState> emit,
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
          case ToOverlayMsgConfig():
          case ToOverlayMsgNewLyricSaved():
          case ToOverlayMsgMediaState():
            return state.copyWith();
        }
      },
    );
  }
}
