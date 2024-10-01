import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_from_main_receiver_bloc.freezed.dart';
part 'message_from_main_receiver_event.dart';
part 'message_from_main_receiver_state.dart';

class MessageFromMainReceiverBloc extends Bloc<MessageFromMainReceiverEvent, MessageFromMainReceiverState> {
  MessageFromMainReceiverBloc() : super(const MessageFromMainReceiverState()) {
    on<MessageFromMainReceiverEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
