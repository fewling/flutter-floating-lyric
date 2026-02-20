part of 'msg_from_main_bloc.dart';

@freezed
sealed class MsgFromMainEvent with _$MsgFromMainEvent {
  const factory MsgFromMainEvent.started() = _Started;

  const factory MsgFromMainEvent.newLyricHandled() = _NewLyricHandled;
}
