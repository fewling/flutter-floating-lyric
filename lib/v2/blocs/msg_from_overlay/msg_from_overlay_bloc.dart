import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../configs/main_overlay/main_overlay_port.dart';
import '../../mixins/isolates_mixin.dart';
import '../../models/to_main_msg.dart';

part 'msg_from_overlay_bloc.freezed.dart';
part 'msg_from_overlay_event.dart';
part 'msg_from_overlay_state.dart';

class MsgFromOverlayBloc extends Bloc<MsgFromOverlayEvent, MsgFromOverlayState>
    with IsolatesMixin {
  MsgFromOverlayBloc() : super(const MsgFromOverlayState()) {
    _receivePort = ReceivePort();

    on<MsgFromOverlayEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _Handled() => _onMsgHandled(event, emit),
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
    Emitter<MsgFromOverlayState> emit,
  ) async {
    await registerPort(_receivePort.sendPort, MainOverlayPort.mainPortName.key);

    await emit.forEach(
      _receivePort.asBroadcastStream(),
      onData: (data) {
        final msg = ToMainMsg.fromJson(data as Map<String, dynamic>);
        return state.copyWith(msg: msg);
      },
    );
  }

  void _onMsgHandled(_Handled event, Emitter<MsgFromOverlayState> emit) =>
      emit(state.copyWith(msg: null));
}
