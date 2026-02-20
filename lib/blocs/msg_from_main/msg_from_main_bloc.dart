import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/async_status.dart';
import '../../enums/main_overlay_port.dart';
import '../../enums/search_lyric_status.dart';
import '../../models/lrc.dart';
import '../../models/media_state.dart';
import '../../models/overlay_window_config.dart';
import '../../models/to_overlay_msg_model.dart';
import '../../utils/logger.dart';
import '../../utils/mixins/isolates_mixin.dart';

part 'msg_from_main_bloc.freezed.dart';
part 'msg_from_main_event.dart';
part 'msg_from_main_state.dart';

class MsgFromMainBloc extends Bloc<MsgFromMainEvent, MsgFromMainState>
    with IsolatesMixin {
  MsgFromMainBloc()
    : super(const MsgFromMainState(config: null, mediaState: null)) {
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
    emit(state.copyWith(isolateRegistrationStatus: AsyncStatus.loading));

    final isSuccess = await registerPort(
      _receivePort.sendPort,
      MainOverlayPort.overlayPortName.key,
    );

    emit(
      state.copyWith(
        isolateRegistrationStatus: isSuccess
            ? AsyncStatus.success
            : AsyncStatus.failure,
      ),
    );

    await emit.forEach(
      _receivePort.asBroadcastStream(),
      onData: (data) {
        final msg = ToOverlayMsgModel.fromJson(data as Map<String, dynamic>);

        switch (msg) {
          case ToOverlayMsgConfig():
            logger.d('>>> Received message from main: ${msg.runtimeType}');
            return state.copyWith(config: msg.config);

          case ToOverlayMsgMediaState():
            return state.copyWith(mediaState: msg.mediaState);

          case ToOverlayMsgLrcState():
            logger.d(
              '>>> Received lyric update from main:\nsearchLyricStatus=${msg.searchLyricStatus}\nlrc=${msg.lrc}',
            );
            return state.copyWith(
              currentLrc: msg.lrc,
              searchLyricStatus: msg.searchLyricStatus,
            );

          case ToOverlayMsgDeviceWidth():
            logger.d(
              '>>> Received device width update from main: ${msg.width}',
            );
            return state.copyWith(deviceWidth: msg.width);
        }
      },
    );
  }
}
