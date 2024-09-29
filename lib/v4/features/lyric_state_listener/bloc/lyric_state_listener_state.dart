part of 'lyric_state_listener_bloc.dart';

@freezed
class LyricStateListenerState with _$LyricStateListenerState {
  const factory LyricStateListenerState({
    @Default(null) MediaState? mediaState,
    Lrc? currentLrc,
    String? currentLine,
    @Default(false) bool isAutoFetch,
    @Default(false) bool shouldSearchOnline,
    @Default(false) bool isSearchingOnline,
  }) = _LyricStateListenerState;

  factory LyricStateListenerState.fromJson(Map<String, dynamic> json) => _$LyricStateListenerStateFromJson(json);
}
