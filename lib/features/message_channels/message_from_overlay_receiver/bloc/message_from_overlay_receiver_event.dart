part of 'message_from_overlay_receiver_bloc.dart';

sealed class MessageFromOverlayReceiverEvent {
  const MessageFromOverlayReceiverEvent();
}

final class MessageFromOverlayReceiverStarted
    extends MessageFromOverlayReceiverEvent {
  const MessageFromOverlayReceiverStarted();
}

final class MsgOverlayHandled extends MessageFromOverlayReceiverEvent {
  const MsgOverlayHandled();
}
