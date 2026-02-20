import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_state.freezed.dart';
part 'media_state.g.dart';

@freezed
sealed class MediaState with _$MediaState {
  const factory MediaState({
    required String mediaPlayerName,
    required String title,
    required String artist,
    required String album,
    required double position,
    required double duration,
    required bool isPlaying,
  }) = _MediaState;

  factory MediaState.fromJson(Map<String, dynamic> json) =>
      _$MediaStateFromJson(json);
}

extension MediaStateExtension on MediaState {
  bool isSameMedia(MediaState other) =>
      title == other.title &&
      artist == other.artist &&
      album == other.album &&
      duration == other.duration;

  String get positionStr => Duration(
    seconds: position.toInt(),
  ).toString().split('.').first.padLeft(8, '0');

  String get durationStr => Duration(
    seconds: duration.toInt(),
  ).toString().split('.').first.padLeft(8, '0');
}
