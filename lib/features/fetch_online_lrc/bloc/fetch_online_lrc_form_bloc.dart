import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../repos/remote/lrclib/lrclib_repository.dart';
import '../../../service/db/local/local_db_service.dart';
import '../../../service/lrc_lib/lrc_lib_service.dart';
import '../../../utils/logger.dart';

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
        ErrorResponseHandled() => _onErrorHandled(event, emit),
        EditFieldRequested() => _onEditFieldRequested(event, emit),
        SaveLyricResponseRequested() => _onSaveLyricRequested(event, emit),
        SaveTitleAltRequested() => _onSaveTitleAltRequested(event, emit),
        SaveArtistAltRequested() => _onSaveArtistAltRequested(event, emit),
        SaveAlbumAltRequested() => _onSaveAlbumAltRequested(event, emit),
        SaveResponseHandled() => _onSaveResponseHandled(event, emit),
      },
    );
  }

  final LrcLibService _lrcLibService;
  final LocalDbService _localDbService;

  void _onStarted(FetchOnlineLrcFormStarted event, Emitter<FetchOnlineLrcFormState> emit) {
    logger.w('FetchOnlineLrcFormBloc._onStarted');
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
    logger.w('FetchOnlineLrcFormBloc._onNewSongPlayed');
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
    logger.w('FetchOnlineLrcFormBloc._onSearchRequested');
    try {
      logger.d('FetchOnlineLrcFormBloc._onSearchRequested1: requestStatus: ${state.requestStatus}');
      emit(state.copyWith(
        requestStatus: OnlineLrcRequestStatus.loading,
        lrcLibResponse: null,
      ));
      logger.d('FetchOnlineLrcFormBloc._onSearchRequested2: requestStatus: ${state.requestStatus}');

      final response = await _lrcLibService.fetch(
        trackName: state.titleAlt ?? 'unknown',
        artistName: state.artistAlt ?? 'unknown',
        albumName: state.albumAlt ?? 'unknown',
        duration: (state.duration ?? 0) ~/ 1000,
      );

      emit(state.copyWith(
        requestStatus: OnlineLrcRequestStatus.success,
        lrcLibResponse: response,
      ));
    } catch (e) {
      logger.e('FetchOnlineLrcFormBloc._onSearchRequested: $e');
      emit(state.copyWith(
        requestStatus: OnlineLrcRequestStatus.failure,
        lrcLibResponse: null,
      ));
    }
  }

  void _onErrorHandled(ErrorResponseHandled event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      requestStatus: OnlineLrcRequestStatus.initial,
      lrcLibResponse: null,
    ));
  }

  void _onEditFieldRequested(EditFieldRequested event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      isEditingTitle: event.isTitle,
      isEditingArtist: event.isArtist,
      isEditingAlbum: event.isAlbum,
    ));
  }

  Future<void> _onSaveLyricRequested(SaveLyricResponseRequested event, Emitter<FetchOnlineLrcFormState> emit) async {
    emit(state.copyWith(
      saveLrcStatus: SaveLrcStatus.saving,
    ));
    try {
      await _localDbService.saveLrc(
        title: state.title ?? state.titleAlt ?? 'unknown',
        artist: state.artist ?? state.artistAlt ?? 'unknown',
        content: event.response.syncedLyrics,
      );
      emit(state.copyWith(
        saveLrcStatus: SaveLrcStatus.success,
      ));
    } catch (e) {
      logger.e('FetchOnlineLrcFormBloc._onSaveLyricRequested: $e');
      emit(state.copyWith(
        saveLrcStatus: SaveLrcStatus.failure,
      ));
      return;
    }
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

  void _onSaveResponseHandled(SaveResponseHandled event, Emitter<FetchOnlineLrcFormState> emit) {
    emit(state.copyWith(
      saveLrcStatus: SaveLrcStatus.initial,
    ));
  }
}
