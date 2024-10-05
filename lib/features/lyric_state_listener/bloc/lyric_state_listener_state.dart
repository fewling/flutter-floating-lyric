part of 'lyric_state_listener_bloc.dart';

@freezed
class LyricStateListenerState with _$LyricStateListenerState {
  const factory LyricStateListenerState({
    @Default(null) MediaState? mediaState,
    Lrc? currentLrc,
    LrcLine? line1,
    LrcLine? line2,
    @Default(false) bool isAutoFetch,
    @Default(false) bool shouldSearchOnline,
    @Default(false) bool isSearchingOnline,
    @Default(false) bool showLine2,
    @Default(LastUpdatedLine.line1) LastUpdatedLine lastUpdatedLine,
  }) = _LyricStateListenerState;

  factory LyricStateListenerState.fromJson(Map<String, dynamic> json) => _$LyricStateListenerStateFromJson(json);
}

enum LastUpdatedLine { line1, line2 }

extension LastUpdatedLineX on LastUpdatedLine {
  bool get isLine1 => this == LastUpdatedLine.line1;
  bool get isLine2 => this == LastUpdatedLine.line2;
}
