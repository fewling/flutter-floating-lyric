import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../configs/main_overlay/main_overlay_port.dart';
import '../../../../models/from_overlay_msg_model.dart';
import '../../../../v2/mixins/isolates_mixin.dart';

part 'message_from_overlay_receiver_bloc.freezed.dart';
part 'message_from_overlay_receiver_bloc.g.dart';
part 'message_from_overlay_receiver_event.dart';
part 'message_from_overlay_receiver_state.dart';

class MessageFromOverlayReceiverBloc
    extends
        Bloc<MessageFromOverlayReceiverEvent, MessageFromOverlayReceiverState>
    with IsolatesMixin {
  MessageFromOverlayReceiverBloc()
    : super(const MessageFromOverlayReceiverState()) {
    _receivePort = ReceivePort();

    on<MessageFromOverlayReceiverEvent>(
      (event, emit) => switch (event) {
        MessageFromOverlayReceiverStarted() => _onStarted(event, emit),
        MsgOverlayHandled() => _onMsgHandled(event, emit),
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
    MessageFromOverlayReceiverStarted event,
    Emitter<MessageFromOverlayReceiverState> emit,
  ) async {
    await registerPort(_receivePort.sendPort, MainOverlayPort.mainPortName.key);

    await emit.forEach(
      _receivePort.asBroadcastStream(),
      onData: (data) {
        final msg = FromOverlayMsgModel.fromJson(data as Map<String, dynamic>);
        return state.copyWith(msg: msg);
      },
    );
  }

  void _onMsgHandled(
    MsgOverlayHandled event,
    Emitter<MessageFromOverlayReceiverState> emit,
  ) {
    emit(state.copyWith(msg: null));
  }
}
