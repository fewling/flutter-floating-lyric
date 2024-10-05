part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class MediaStateChanged extends HomeEvent {
  const MediaStateChanged(this.mediaState);

  final MediaState? mediaState;
}

final class StartMusicPlayerRequested extends HomeEvent {
  const StartMusicPlayerRequested();
}

final class HomeStarted extends HomeEvent {
  const HomeStarted({this.mediaState});

  final MediaState? mediaState;
}
