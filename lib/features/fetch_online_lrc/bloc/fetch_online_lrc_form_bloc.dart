import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/db/local/local_db_service.dart';
import '../../../service/lrc_lib/lrc_lib_service.dart';
import '../../../services/lrclib/data/lrclib_response.dart';

part 'fetch_online_lrc_form_bloc.freezed.dart';
part 'fetch_online_lrc_form_event.dart';
part 'fetch_online_lrc_form_state.dart';

class FetchOnlineLrcFormBloc extends Bloc<FetchOnlineLrcFormEvent, FetchOnlineLrcFormState> {
  FetchOnlineLrcFormBloc({
    required LrcLibService lrcLibService,
    required LocalDbService localDbService,
  })  : _lrcLibService = lrcLibService,
        _localDbService = localDbService,
        super(const FetchOnlineLrcFormState()) {
    on<FetchOnlineLrcFormEvent>(
      (event, emit) => switch (event) {
        FetchOnlineLrcFormStarted() => _onStarted(event, emit),
        NewSongPlayed() => _onNewSongPlayed(event, emit),
        SearchOnlineRequested() => _onSearchRequested(event, emit),
        SearchResponseReceived() => _onResponseReceived(event, emit),
        EditFieldRequested() => _onEditFieldRequested(event, emit),
        SaveLyricResponseRequested() => _onSaveLyricRequested(event, emit),
        SaveTitleAltRequested() => _onSaveTitleAltRequested(event, emit),
        SaveArtistAltRequested() => _onSaveArtistAltRequested(event, emit),
        SaveAlbumAltRequested() => _onSaveAlbumAltRequested(event, emit),
      },
    );
  }

  final LrcLibService _lrcLibService;
  final LocalDbService _localDbService;

  void _onStarted(FetchOnlineLrcFormStarted event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      album: event.album,
      artist: event.artist,
      title: event.title,
      albumAlt: event.album,
      artistAlt: event.artist,
      titleAlt: event.title,
      duration: event.duration,
    ));
  }

  void _onNewSongPlayed(NewSongPlayed event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      album: event.album,
      artist: event.artist,
      title: event.title,
      albumAlt: event.album,
      artistAlt: event.artist,
      titleAlt: event.title,
      duration: event.duration,
    ));
  }

  Future<void> _onSearchRequested(SearchOnlineRequested event, Emitter<FetchOnlineLrcFormState> emit) async {
    try {
      emit(state.copyWith(
        isSearchingOnline: true,
        lrcLibResponse: null,
      ));

      final response = await _lrcLibService.fetch(
        trackName: state.titleAlt ?? 'unknown',
        artistName: state.artistAlt ?? 'unknown',
        albumName: state.albumAlt ?? 'unknown',
        duration: (state.duration ?? 0) ~/ 1000,
      );

      emit(state.copyWith(
        isSearchingOnline: false,
        lrcLibResponse: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSearchingOnline: false,
        lrcLibResponse: null,
      ));
    }
  }

  void _onResponseReceived(SearchResponseReceived event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(lrcLibResponse: null));
  }

  void _onEditFieldRequested(EditFieldRequested event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      isEditingTitle: event.isTitle,
      isEditingArtist: event.isArtist,
      isEditingAlbum: event.isAlbum,
    ));
  }

  Future<void> _onSaveLyricRequested(SaveLyricResponseRequested event, Emitter<FetchOnlineLrcFormState> emit) async {
    await _localDbService.saveLrc(
      title: state.titleAlt ?? state.title ?? 'unknown',
      artist: state.artistAlt ?? state.artist ?? 'unknown',
      content: event.response.syncedLyrics,
    );
  }

  void _onSaveTitleAltRequested(SaveTitleAltRequested event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      titleAlt: event.title,
      isEditingTitle: false,
    ));
  }

  void _onSaveArtistAltRequested(SaveArtistAltRequested event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      artistAlt: event.artist,
      isEditingArtist: false,
    ));
  }

  void _onSaveAlbumAltRequested(SaveAlbumAltRequested event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      albumAlt: event.album,
      isEditingAlbum: false,
    ));
  }
}
