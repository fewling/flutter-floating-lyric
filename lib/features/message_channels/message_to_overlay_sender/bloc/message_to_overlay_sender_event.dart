part of 'message_to_overlay_sender_bloc.dart';

sealed class MessageToOverlaySenderEvent {
  const MessageToOverlaySenderEvent();
}

final class MessageToOverlaySenderStarted extends MessageToOverlaySenderEvent {
  const MessageToOverlaySenderStarted();
}
