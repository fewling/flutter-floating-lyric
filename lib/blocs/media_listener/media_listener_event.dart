part of 'media_listener_bloc.dart';

@freezed
sealed class MediaListenerEvent with _$MediaListenerEvent {
  const factory MediaListenerEvent.started() = _Started;
}
