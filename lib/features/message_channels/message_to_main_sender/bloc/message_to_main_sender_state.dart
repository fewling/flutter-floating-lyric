part of 'message_to_main_sender_bloc.dart';

@freezed
class MessageToMainSenderState with _$MessageToMainSenderState {
  const factory MessageToMainSenderState() = _MessageToMainSenderState;

  factory MessageToMainSenderState.fromJson(Map<String, dynamic> json) => _$MessageToMainSenderStateFromJson(json);
}
