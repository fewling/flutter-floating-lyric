part of 'msg_from_overlay_bloc.dart';

@freezed
sealed class MsgFromOverlayState with _$MsgFromOverlayState {
  const factory MsgFromOverlayState({ToMainMsg? msg}) = _MsgFromOverlayState;
}
