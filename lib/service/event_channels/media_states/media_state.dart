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
