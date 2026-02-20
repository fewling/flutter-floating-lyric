part of 'overlay_window_bloc.dart';

@freezed
sealed class OverlayWindowState with _$OverlayWindowState {
  const factory OverlayWindowState({
    @Default(false) bool isLyricOnly,
    @Default(false) bool isLocked,

    Lrc? currentLrc,
    @Default(SearchLyricStatus.initial) SearchLyricStatus lyricSearchStatus,

    MediaState? mediaState,

    @Default(OverlayWindowConfig()) OverlayWindowConfig config,

    /// All lyric lines from the current song
    @Default(<LrcLine>[]) List<LrcLine> allLines,

    /// Index of the current (active) line in allLines
    @Default(0) int currentLineIndex,
  }) = _OverlayWindowState;
}
