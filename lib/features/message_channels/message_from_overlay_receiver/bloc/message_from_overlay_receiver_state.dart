part of 'message_from_overlay_receiver_bloc.dart';

@freezed
class MessageFromOverlayReceiverState with _$MessageFromOverlayReceiverState {
  const factory MessageFromOverlayReceiverState({FromOverlayMsgModel? msg}) =
      _MessageFromOverlayReceiverState;

  factory MessageFromOverlayReceiverState.fromJson(Map<String, dynamic> json) =>
      _$MessageFromOverlayReceiverStateFromJson(json);
}
