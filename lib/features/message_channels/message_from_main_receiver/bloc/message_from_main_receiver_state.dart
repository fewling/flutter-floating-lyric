part of 'message_from_main_receiver_bloc.dart';

@freezed
sealed class MessageFromMainReceiverState with _$MessageFromMainReceiverState {
  const factory MessageFromMainReceiverState({OverlaySettingsModel? settings}) =
      _MessageFromMainReceiverState;

  factory MessageFromMainReceiverState.fromJson(Map<String, dynamic> json) =>
      _$MessageFromMainReceiverStateFromJson(json);
}
