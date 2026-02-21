import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/to_main_msg.dart';
import '../../services/msg_channels/to_main_msg_service.dart';

part 'msg_to_main_bloc.freezed.dart';
part 'msg_to_main_event.dart';
part 'msg_to_main_state.dart';

class MsgToMainBloc extends Bloc<MsgToMainEvent, MsgToMainState> {
  MsgToMainBloc({required ToMainMsgService toMainMsgService})
    : _toMainMsgService = toMainMsgService,
      super(const MsgToMainState()) {
    on<MsgToMainEvent>(
      (event, emit) => switch (event) {
        _CloseOverlay() => _onCloseOverlay(event, emit),
      },
    );
  }

  final ToMainMsgService _toMainMsgService;

  void _onCloseOverlay(_CloseOverlay event, Emitter<MsgToMainState> emit) =>
      _toMainMsgService.sendMsg(const ToMainMsg.closeOverlay());
}
