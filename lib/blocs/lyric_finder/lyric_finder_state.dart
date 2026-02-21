// ignore_for_file: invalid_annotation_target

part of 'lyric_finder_bloc.dart';

@freezed
sealed class LyricFinderState with _$LyricFinderState {
  const factory LyricFinderState({
    Lrc? currentLrc,

    @Default(true) bool isAutoFetch,

    @JsonKey(
      fromJson: searchLyricStatusFromJson,
      toJson: searchLyricStatusToJson,
    )
    @Default(SearchLyricStatus.initial)
    SearchLyricStatus status,
  }) = _LyricFinderState;

  factory LyricFinderState.fromJson(Map<String, dynamic> json) =>
      _$LyricFinderStateFromJson(json);
}
