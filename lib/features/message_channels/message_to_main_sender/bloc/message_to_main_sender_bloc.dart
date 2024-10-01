import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_to_main_sender_bloc.freezed.dart';
part 'message_to_main_sender_event.dart';
part 'message_to_main_sender_state.dart';

class MessageToMainSenderBloc extends Bloc<MessageToMainSenderEvent, MessageToMainSenderState> {
  MessageToMainSenderBloc() : super(const MessageToMainSenderState()) {
    on<MessageToMainSenderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
