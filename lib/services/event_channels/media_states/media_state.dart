import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_state.freezed.dart';

@freezed
class MediaState with _$MediaState {
  const factory MediaState({
    required String mediaPlayerName,
    required String title,
    required String artist,
    required String album,
    required double position,
    required double duration,
    required bool isPlaying,
  }) = _MediaState;
}
