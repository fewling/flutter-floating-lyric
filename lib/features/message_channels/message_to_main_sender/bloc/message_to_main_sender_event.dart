part of 'message_to_main_sender_bloc.dart';

sealed class MessageToMainSenderEvent {
  const MessageToMainSenderEvent();
}

final class MessageToMainSenderStarted extends MessageToMainSenderEvent {
  const MessageToMainSenderStarted();
}
