import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../repos/lrclib/lrclib_repository.dart';
import '../../utils/logger.dart';
import '../../utils/mixins/custom_exception/custom_exception_handler.dart';

part 'fetch_online_lrc_form_bloc.freezed.dart';
part 'fetch_online_lrc_form_event.dart';
part 'fetch_online_lrc_form_state.dart';

class FetchOnlineLrcFormBloc
    extends Bloc<FetchOnlineLrcFormEvent, FetchOnlineLrcFormState> {
  FetchOnlineLrcFormBloc({required LrcLibRepository lrcLibRepo})
    : _lrcLibRepo = lrcLibRepo,
      super(const FetchOnlineLrcFormState()) {
    on<FetchOnlineLrcFormEvent>(
      (event, emit) => switch (event) {
        FetchOnlineLrcFormStarted() => _onStarted(event, emit),
        NewSongPlayed() => _onNewSongPlayed(event, emit),
        SearchOnlineRequested() => _onSearchRequested(event, emit),
        ErrorResponseHandled() => _onErrorHandled(event, emit),
        EditFieldRequested() => _onEditFieldRequested(event, emit),
        SaveTitleAltRequested() => _onSaveTitleAltRequested(event, emit),
        SaveArtistAltRequested() => _onSaveArtistAltRequested(event, emit),
        SaveAlbumAltRequested() => _onSaveAlbumAltRequested(event, emit),
      },
    );
  }

  final LrcLibRepository _lrcLibRepo;

  void _onStarted(
    FetchOnlineLrcFormStarted event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(
      state.copyWith(
        album: event.album,
        artist: event.artist,
        title: event.title,
        albumAlt: event.album,
        artistAlt: event.artist,
        titleAlt: event.title,
        duration: event.duration,
      ),
    );
  }

  void _onNewSongPlayed(
    NewSongPlayed event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(
      state.copyWith(
        album: event.album,
        artist: event.artist,
        title: event.title,
        albumAlt: event.album,
        artistAlt: event.artist,
        titleAlt: event.title,
        duration: event.duration,
      ),
    );
  }

  Future<void> _onSearchRequested(
    SearchOnlineRequested event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          requestStatus: OnlineLrcRequestStatus.loading,
          lrcLibResponse: null,
        ),
      );

      final res = await _lrcLibRepo.getLyric(
        trackName: state.titleAlt ?? 'unknown',
        artistName: state.artistAlt ?? 'unknown',
        albumName: state.albumAlt ?? 'unknown',
        duration: (state.duration ?? 0) ~/ 1000,
      );

      switch (res) {
        case Success<LrcLibResponse, CustomException>():
          emit(
            state.copyWith(
              requestStatus: OnlineLrcRequestStatus.success,
              lrcLibResponse: res.value,
            ),
          );

        case Failure<LrcLibResponse, CustomException>():
          logger.e(
            'FetchOnlineLrcFormBloc._onSearchRequested: ${res.exception}',
          );
          emit(
            state.copyWith(
              requestStatus: OnlineLrcRequestStatus.failure,
              lrcLibResponse: null,
            ),
          );
      }
    } catch (e) {
      logger.e('FetchOnlineLrcFormBloc._onSearchRequested: $e');
      emit(
        state.copyWith(
          requestStatus: OnlineLrcRequestStatus.failure,
          lrcLibResponse: null,
        ),
      );
    }
  }

  void _onErrorHandled(
    ErrorResponseHandled event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(
      state.copyWith(
        requestStatus: OnlineLrcRequestStatus.initial,
        lrcLibResponse: null,
      ),
    );
  }

  void _onEditFieldRequested(
    EditFieldRequested event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(
      state.copyWith(
        isEditingTitle: event.isTitle,
        isEditingArtist: event.isArtist,
        isEditingAlbum: event.isAlbum,
      ),
    );
  }

  void _onSaveTitleAltRequested(
    SaveTitleAltRequested event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(state.copyWith(titleAlt: event.title, isEditingTitle: false));
  }

  void _onSaveArtistAltRequested(
    SaveArtistAltRequested event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(state.copyWith(artistAlt: event.artist, isEditingArtist: false));
  }

  void _onSaveAlbumAltRequested(
    SaveAlbumAltRequested event,
    Emitter<FetchOnlineLrcFormState> emit,
  ) {
    emit(state.copyWith(albumAlt: event.album, isEditingAlbum: false));
  }
}
