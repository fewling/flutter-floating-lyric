import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_to_overlay_sender_bloc.freezed.dart';
part 'message_to_overlay_sender_event.dart';
part 'message_to_overlay_sender_state.dart';

class MessageToOverlaySenderBloc extends Bloc<MessageToOverlaySenderEvent, MessageToOverlaySenderState> {
  MessageToOverlaySenderBloc() : super(const MessageToOverlaySenderState()) {
    on<MessageToOverlaySenderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
