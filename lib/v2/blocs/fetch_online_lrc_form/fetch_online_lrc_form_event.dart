part of 'fetch_online_lrc_form_bloc.dart';

sealed class FetchOnlineLrcFormEvent {
  const FetchOnlineLrcFormEvent();
}

final class FetchOnlineLrcFormStarted extends FetchOnlineLrcFormEvent {
  const FetchOnlineLrcFormStarted({
    this.title,
    this.artist,
    this.album,
    this.duration,
  });

  final String? title;
  final String? artist;
  final String? album;
  final double? duration;
}

final class NewSongPlayed extends FetchOnlineLrcFormEvent {
  const NewSongPlayed({this.title, this.artist, this.album, this.duration});

  final String? title;
  final String? artist;
  final String? album;
  final double? duration;
}

final class SearchOnlineRequested extends FetchOnlineLrcFormEvent {
  const SearchOnlineRequested();
}

final class EditFieldRequested extends FetchOnlineLrcFormEvent {
  const EditFieldRequested({
    this.isTitle = false,
    this.isArtist = false,
    this.isAlbum = false,
  });

  final bool isTitle;
  final bool isArtist;
  final bool isAlbum;
}

final class SaveLyricResponseRequested extends FetchOnlineLrcFormEvent {
  const SaveLyricResponseRequested(this.response);

  final LrcLibResponse response;
}

final class SaveTitleAltRequested extends FetchOnlineLrcFormEvent {
  const SaveTitleAltRequested(this.title);

  final String title;
}

final class SaveArtistAltRequested extends FetchOnlineLrcFormEvent {
  const SaveArtistAltRequested(this.artist);

  final String artist;
}

final class SaveAlbumAltRequested extends FetchOnlineLrcFormEvent {
  const SaveAlbumAltRequested(this.album);

  final String album;
}

final class ErrorResponseHandled extends FetchOnlineLrcFormEvent {
  const ErrorResponseHandled();
}

final class SaveResponseHandled extends FetchOnlineLrcFormEvent {
  const SaveResponseHandled();
}
