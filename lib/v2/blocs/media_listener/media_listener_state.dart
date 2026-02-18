part of 'media_listener_bloc.dart';

@freezed
sealed class MediaListenerState with _$MediaListenerState {
  const factory MediaListenerState({
    @Default(<MediaState>[]) List<MediaState> mediaStates,
  }) = _MediaListenerState;
}
