import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/overlay_settings_model.dart';

part 'message_from_main_receiver_bloc.freezed.dart';
part 'message_from_main_receiver_bloc.g.dart';
part 'message_from_main_receiver_event.dart';
part 'message_from_main_receiver_state.dart';

class MessageFromMainReceiverBloc extends Bloc<MessageFromMainReceiverEvent, MessageFromMainReceiverState> {
  MessageFromMainReceiverBloc() : super(const MessageFromMainReceiverState()) {
    on<MessageFromMainReceiverEvent>(
      (event, emit) => switch (event) {
        MessageFromMainReceiverStarted() => _onStarted(event, emit),
      },
    );
  }

  void _onStarted(MessageFromMainReceiverStarted event, Emitter<MessageFromMainReceiverState> emit) => emit.forEach(
        FlutterOverlayWindow.overlayListener,
        onData: (data) {
          final newSettings = OverlaySettingsModel.fromJson(data as Map<String, dynamic>);
          return state.copyWith(settings: newSettings);
        },
      );
}
