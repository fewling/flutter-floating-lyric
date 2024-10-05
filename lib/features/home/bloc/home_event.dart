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

final class SearchOnlineRequested extends HomeEvent {
  const SearchOnlineRequested();
}

final class SearchResponseReceived extends HomeEvent {
  const SearchResponseReceived();
}

final class EditFieldRequested extends HomeEvent {
  const EditFieldRequested({
    this.isTitle = false,
    this.isArtist = false,
    this.isAlbum = false,
  });

  final bool isTitle;
  final bool isArtist;
  final bool isAlbum;
}

final class SaveLyricResponseRequested extends HomeEvent {
  const SaveLyricResponseRequested(this.response);

  final LrcLibResponse response;
}

final class SaveTitleAltRequested extends HomeEvent {
  const SaveTitleAltRequested(this.title);

  final String title;
}

final class SaveArtistAltRequested extends HomeEvent {
  const SaveArtistAltRequested(this.artist);

  final String artist;
}

final class SaveAlbumAltRequested extends HomeEvent {
  const SaveAlbumAltRequested(this.album);

  final String album;
}

final class NewSongPlayed extends HomeEvent {
  const NewSongPlayed(this.mediaState);

  final MediaState? mediaState;
}

final class HomeStarted extends HomeEvent {
  const HomeStarted({this.mediaState});

  final MediaState? mediaState;
}
