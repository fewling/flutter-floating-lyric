import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/db/local/local_db_service.dart';
import '../../../service/lrc_lib/lrc_lib_service.dart';
import '../../../service/permissions/permission_service.dart';
import '../../../services/event_channels/media_states/media_state.dart';
import '../../../services/lrclib/data/lrclib_response.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PermissionService permissionService,
    required LrcLibService lrcLibService,
    required LocalDbService localDbService,
  })  : _permissionService = permissionService,
        _lrcLibService = lrcLibService,
        _localDbService = localDbService,
        super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        HomeStarted() => _onStarted(event, emit),
        StartMusicPlayerRequested() => _onStartMusicPlayerRequested(event, emit),
        SearchOnlineRequested() => _onSearchOnlineRequested(event, emit),
        SearchResponseReceived() => _onSearchResponseReceived(event, emit),
        EditFieldRequested() => _onEditFieldRequested(event, emit),
        SaveLyricResponseRequested() => _onSaveLyricResponseRequested(event, emit),
        SaveTitleAltRequested() => _onSaveTitleAltRequested(event, emit),
        SaveArtistAltRequested() => _onSaveArtistAltRequested(event, emit),
        SaveAlbumAltRequested() => _onSaveAlbumAltRequested(event, emit),
        MediaStateChanged() => _onMediaStateChanged(event, emit),
        NewSongPlayed() => _onNewSongPlayed(event, emit),
      },
    );
  }

  final PermissionService _permissionService;
  final LrcLibService _lrcLibService;
  final LocalDbService _localDbService;

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      mediaState: event.mediaState,
      albumAlt: event.mediaState?.album,
      artistAlt: event.mediaState?.artist,
      titleAlt: event.mediaState?.title,
    ));
  }

  void _onStartMusicPlayerRequested(StartMusicPlayerRequested event, Emitter<HomeState> emit) {
    _permissionService.start3rdMusicPlayer();
  }

  Future<void> _onSearchOnlineRequested(SearchOnlineRequested event, Emitter<HomeState> emit) async {
    if (state.mediaState == null) return;

    try {
      emit(state.copyWith(
        isSearchingOnline: true,
        lrcLibResponse: null,
      ));

      final response = await _lrcLibService.fetch(
        trackName: state.titleAlt ?? state.mediaState!.title,
        artistName: state.artistAlt ?? state.mediaState!.artist,
        albumName: state.albumAlt ?? state.mediaState!.album,
        duration: state.mediaState!.duration ~/ 1000,
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

  void _onSearchResponseReceived(SearchResponseReceived event, Emitter<HomeState> emit) {
    emit(state.copyWith(lrcLibResponse: null));
  }

  void _onEditFieldRequested(EditFieldRequested event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      isEditingTitle: event.isTitle,
      isEditingArtist: event.isArtist,
      isEditingAlbum: event.isAlbum,
    ));
  }

  Future<void> _onSaveLyricResponseRequested(SaveLyricResponseRequested event, Emitter<HomeState> emit) async {
    final media = state.mediaState;
    if (media == null) return;

    await _localDbService.saveLrc(
      title: media.title,
      artist: media.artist,
      content: event.response.syncedLyrics,
    );
  }

  void _onSaveTitleAltRequested(SaveTitleAltRequested event, Emitter<HomeState> emit) {
    emit(state.copyWith(titleAlt: event.title, isEditingTitle: false));
  }

  void _onSaveArtistAltRequested(SaveArtistAltRequested event, Emitter<HomeState> emit) {
    emit(state.copyWith(artistAlt: event.artist, isEditingArtist: false));
  }

  void _onSaveAlbumAltRequested(SaveAlbumAltRequested event, Emitter<HomeState> emit) {
    emit(state.copyWith(albumAlt: event.album, isEditingAlbum: false));
  }

  void _onMediaStateChanged(MediaStateChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      mediaState: event.mediaState,
    ));
  }

  void _onNewSongPlayed(NewSongPlayed event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      mediaState: event.mediaState,
      titleAlt: event.mediaState?.title,
      artistAlt: event.mediaState?.artist,
      albumAlt: event.mediaState?.album,
    ));
  }
}
