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
    @JsonKey(fromJson: searchLyricStatusFromJson, toJson: searchLyricStatusToJson)
    @Default(SearchLyricStatus.initial)
    SearchLyricStatus searchLyricStatus,
  }) = _LyricStateListenerState;

  factory LyricStateListenerState.fromJson(Map<String, dynamic> json) => _$LyricStateListenerStateFromJson(json);
}
