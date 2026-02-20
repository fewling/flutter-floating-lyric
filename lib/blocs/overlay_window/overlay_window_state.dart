part of 'overlay_window_bloc.dart';

@freezed
sealed class OverlayWindowState with _$OverlayWindowState {
  const factory OverlayWindowState({
    @Default(false) bool isLyricOnly,
    @Default(false) bool isLocked,
    Lrc? currentLrc,
    MediaState? mediaState,

    @Default(OverlayWindowConfig()) OverlayWindowConfig config,

    LrcLine? line1,
    LrcLine? line2,
  }) = _OverlayWindowState;
}
