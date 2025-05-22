part of 'lrclib_repository.dart';

@freezed
class LrcLibResponse with _$LrcLibResponse {
  const factory LrcLibResponse({
    required int id,
    required String name,
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration, // in seconds
    @Default(false) bool instrumental,
    @Default(null) dynamic lang,
    @Default(null) dynamic isrc,
    @Default(null) dynamic spotifyId,
    @Default(null) dynamic releaseDate,
    @Default('') String? plainLyrics,
    @Default('') String? syncedLyrics,
  }) = _LrcLibResponse;

  factory LrcLibResponse.fromJson(Map<String, dynamic> json) =>
      _$LrcLibResponseFromJson(json);
}
