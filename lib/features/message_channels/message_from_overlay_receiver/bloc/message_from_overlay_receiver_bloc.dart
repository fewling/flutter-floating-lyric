import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_from_overlay_receiver_bloc.freezed.dart';
part 'message_from_overlay_receiver_event.dart';
part 'message_from_overlay_receiver_state.dart';

class MessageFromOverlayReceiverBloc extends Bloc<MessageFromOverlayReceiverEvent, MessageFromOverlayReceiverState> {
  MessageFromOverlayReceiverBloc() : super(const MessageFromOverlayReceiverState()) {
    on<MessageFromOverlayReceiverEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
