part of 'msg_from_main_bloc.dart';

@freezed
sealed class MsgFromMainState with _$MsgFromMainState {
  const factory MsgFromMainState({
    required OverlayWindowConfig? config,
    required MediaState? mediaState,
    @Default(NewLyricHandlingStatus.initial)
    NewLyricHandlingStatus newLyricHandlingStatus,
  }) = _MsgFromMainState;
}

enum NewLyricHandlingStatus { initial, received }
