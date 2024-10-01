part of 'message_to_overlay_sender_bloc.dart';

@freezed
class MessageToOverlaySenderState with _$MessageToOverlaySenderState {
  const factory MessageToOverlaySenderState() = _MessageToOverlaySenderState;

  factory MessageToOverlaySenderState.fromJson(Map<String, dynamic> json) =>
      _$MessageToOverlaySenderStateFromJson(json);
}
