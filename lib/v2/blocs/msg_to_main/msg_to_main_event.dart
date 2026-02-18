part of 'msg_to_main_bloc.dart';

@freezed
class MsgToMainEvent with _$MsgToMainEvent {
  const factory MsgToMainEvent.started() = _Started;
}