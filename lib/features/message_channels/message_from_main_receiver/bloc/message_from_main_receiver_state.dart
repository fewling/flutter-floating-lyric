part of 'message_from_main_receiver_bloc.dart';

@freezed
class MessageFromMainReceiverState with _$MessageFromMainReceiverState {
  const factory MessageFromMainReceiverState() = _MessageFromMainReceiverState;

  factory MessageFromMainReceiverState.fromJson(Map<String, dynamic> json) =>
      _$MessageFromMainReceiverStateFromJson(json);
}
