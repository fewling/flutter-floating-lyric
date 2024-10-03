import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../configs/main_overlay/main_overlay_port.dart';
import '../../../../models/overlay_settings_model.dart';
import '../../../../models/to_overlay_msg_model.dart';
import '../../../../utils/logger.dart';

part 'message_from_main_receiver_bloc.freezed.dart';
part 'message_from_main_receiver_bloc.g.dart';
part 'message_from_main_receiver_event.dart';
part 'message_from_main_receiver_state.dart';

class MessageFromMainReceiverBloc extends Bloc<MessageFromMainReceiverEvent, MessageFromMainReceiverState> {
  MessageFromMainReceiverBloc() : super(const MessageFromMainReceiverState()) {
    _receivePort = ReceivePort();

    on<MessageFromMainReceiverEvent>(
      (event, emit) => switch (event) {
        MessageFromMainReceiverStarted() => _onStarted(event, emit),
      },
    );
  }

  late final ReceivePort _receivePort;

  Future<void> _onStarted(
    MessageFromMainReceiverStarted event,
    Emitter<MessageFromMainReceiverState> emit,
  ) async {
    final portName = MainOverlayPort.overlayPortName.key;
    var count = 0;
    var isRegistered = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      portName,
    );
    while (!isRegistered) {
      logger.d('Retrying to register port with name $portName (count: $count)');

      await Future.delayed(const Duration(milliseconds: 100));
      count++;

      IsolateNameServer.removePortNameMapping(portName);

      isRegistered = IsolateNameServer.registerPortWithName(
        _receivePort.sendPort,
        portName,
      );

      if (count > 100) {
        logger.e('Failed to unregister port with name $portName');
        break;
      }
    }

    if (!isRegistered) {
      logger.e('Failed to register port with name $portName');
    } else {
      logger.t('Registered port with name $portName');
    }

    await emit.forEach(
      _receivePort.asBroadcastStream(),
      onData: (data) {
        final msg = ToOverlayMsgModel.fromJson(data as Map<String, dynamic>);
        return state.copyWith(settings: msg.settings);
      },
    );
  }
}
