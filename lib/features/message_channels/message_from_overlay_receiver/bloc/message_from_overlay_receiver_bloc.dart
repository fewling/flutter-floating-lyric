import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../configs/main_overlay/main_overlay_port.dart';
import '../../../../models/from_overlay_msg_model.dart';
import '../../../../service/overlay_window/overlay_window_service.dart';
import '../../../../utils/logger.dart';

part 'message_from_overlay_receiver_bloc.freezed.dart';
part 'message_from_overlay_receiver_bloc.g.dart';
part 'message_from_overlay_receiver_event.dart';
part 'message_from_overlay_receiver_state.dart';

class MessageFromOverlayReceiverBloc extends Bloc<MessageFromOverlayReceiverEvent, MessageFromOverlayReceiverState> {
  MessageFromOverlayReceiverBloc({
    required OverlayWindowService overlayWindowService,
  })  : _overlayWindowService = overlayWindowService,
        super(const MessageFromOverlayReceiverState()) {
    _receivePort = ReceivePort();

    on<MessageFromOverlayReceiverEvent>((event, emit) => switch (event) {
          MessageFromOverlayReceiverStarted() => _onStarted(event, emit),
        });
  }

  final OverlayWindowService _overlayWindowService;

  late final ReceivePort _receivePort;

  Future<void> _onStarted(
    MessageFromOverlayReceiverStarted event,
    Emitter<MessageFromOverlayReceiverState> emit,
  ) async {
    final portName = MainOverlayPort.mainPortName.key;
    var count = 0;
    var isRegistered = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      portName,
    );
    while (!isRegistered) {
      logger.d('Retrying to register port with name ${MainOverlayPort.mainPortName} (count: $count)');

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
        final msg = FromOverlayMsgModel.fromJson(data as Map<String, dynamic>);

        switch (msg.action) {
          case OverlayAction.minimize:
            break;
          case OverlayAction.close:
            _overlayWindowService.close();
            break;
        }

        return state.copyWith(msg: msg);
      },
    );
  }
}
