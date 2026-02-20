part of 'msg_from_overlay_bloc.dart';

@freezed
sealed class MsgFromOverlayEvent with _$MsgFromOverlayEvent {
  const factory MsgFromOverlayEvent.started() = _Started;

  const factory MsgFromOverlayEvent.handled() = _Handled;
}
