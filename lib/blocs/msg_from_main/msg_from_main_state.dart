part of 'msg_from_main_bloc.dart';

@freezed
sealed class MsgFromMainState with _$MsgFromMainState {
  const factory MsgFromMainState({
    required OverlayWindowConfig? config,
    required MediaState? mediaState,

    @Default(AsyncStatus.initial) AsyncStatus isolateRegistrationStatus,

    Lrc? currentLrc,
    @Default(SearchLyricStatus.initial) SearchLyricStatus searchLyricStatus,

    double? deviceWidth,
  }) = _MsgFromMainState;
}
