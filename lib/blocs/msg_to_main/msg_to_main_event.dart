part of 'msg_to_main_bloc.dart';

@freezed
sealed class MsgToMainEvent with _$MsgToMainEvent {
  const factory MsgToMainEvent.closeOverlay() = _CloseOverlay;
}
