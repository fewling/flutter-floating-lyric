part of 'message_from_main_receiver_bloc.dart';

sealed class MessageFromMainReceiverEvent {
  const MessageFromMainReceiverEvent();
}

final class MessageFromMainReceiverStarted
    extends MessageFromMainReceiverEvent {
  const MessageFromMainReceiverStarted();
}
