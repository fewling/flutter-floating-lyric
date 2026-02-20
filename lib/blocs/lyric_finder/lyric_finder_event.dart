part of 'lyric_finder_bloc.dart';

@freezed
sealed class LyricFinderEvent with _$LyricFinderEvent {
  const factory LyricFinderEvent.init({required bool isAutoFetch}) = _Init;

  const factory LyricFinderEvent.mediaStateUpdated(MediaState mediaState) =
      _MediaStateUpdated;

  const factory LyricFinderEvent.autoFetchUpdated(bool isAutoFetch) =
      _AutoFetchUpdated;

  const factory LyricFinderEvent.reset() = _Reset;
}
