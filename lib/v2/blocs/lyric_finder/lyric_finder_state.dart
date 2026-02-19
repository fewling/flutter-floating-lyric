part of 'lyric_finder_bloc.dart';

@freezed
sealed class LyricFinderState with _$LyricFinderState {
  const factory LyricFinderState({
    MediaState? targetMedia,

    Lrc? currentLrc,

    @Default(true) bool isAutoFetch,

    @JsonKey(
      fromJson: lyricFinderStatusFromJson,
      toJson: lyricFinderStatusToJson,
    )
    @Default(LyricFinderStatus.initial)
    LyricFinderStatus status,
  }) = _LyricFinderState;

  factory LyricFinderState.fromJson(Map<String, dynamic> json) =>
      _$LyricFinderStateFromJson(json);
}

enum LyricFinderStatus { initial, empty, searching, found, notFound }

extension LyricFinderStatusX on LyricFinderStatus {
  bool get isInitial => this == LyricFinderStatus.initial;
  bool get isSearching => this == LyricFinderStatus.searching;
  bool get isFound => this == LyricFinderStatus.found;
  bool get isNotFound => this == LyricFinderStatus.notFound;
}

LyricFinderStatus lyricFinderStatusFromJson(String? status) => LyricFinderStatus
    .values
    .firstWhere((e) => '$e' == status, orElse: () => LyricFinderStatus.initial);

String lyricFinderStatusToJson(LyricFinderStatus status) => status.name;
