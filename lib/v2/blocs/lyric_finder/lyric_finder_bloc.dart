import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/lrc.dart';
import '../../../service/db/local/local_db_service.dart';
import '../../../service/event_channels/media_states/media_state.dart';
import '../../../utils/lrc_builder.dart';
import '../../mixins/custom_exception/custom_exception_handler.dart';
import '../../repos/lrclib/lrclib_repository.dart';

part 'lyric_finder_bloc.freezed.dart';
part 'lyric_finder_bloc.g.dart';
part 'lyric_finder_event.dart';
part 'lyric_finder_state.dart';

class LyricFinderBloc extends Bloc<LyricFinderEvent, LyricFinderState> {
  LyricFinderBloc({
    required LocalDbService localDbService,
    required LrcLibRepository lyricRepository,
  }) : _lyricRepository = lyricRepository,
       _localDbService = localDbService,
       super(const LyricFinderState()) {
    on<LyricFinderEvent>(
      (event, emit) => switch (event) {
        _Init() => _onInit(event, emit),
        _MediaStateUpdated() => _onNewSong(event, emit),
        _AutoFetchUpdated() => _onAutoFetchUpdated(event, emit),
        _Reset() => _onReset(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;
  final LrcLibRepository _lyricRepository;

  void _onInit(_Init event, Emitter<LyricFinderState> emit) =>
      emit(state.copyWith(isAutoFetch: event.isAutoFetch));

  Future<void> _onNewSong(
    _MediaStateUpdated event,
    Emitter<LyricFinderState> emit,
  ) async {
    final songInfo = event.mediaState;

    if (state.status.isSearching) return;
    if (state.targetMedia?.isSameMedia(songInfo) ?? false) return;

    emit(
      state.copyWith(
        status: LyricFinderStatus.searching,
        targetMedia: songInfo,
      ),
    );

    final lrcDB = _localDbService.getLyricBySongInfo(
      songInfo.title,
      songInfo.artist,
    );

    // If lyric exists in local DB, use it directly
    if (lrcDB != null) {
      emit(
        state.copyWith(
          currentLrc: LrcBuilder().buildLrc(lrcDB.content ?? ''),
          status: LyricFinderStatus.found,
        ),
      );
      return;
    }

    // Return not found immediately if auto-fetch is disabled
    if (!state.isAutoFetch) {
      emit(state.copyWith(status: LyricFinderStatus.notFound));
      return;
    }

    // Otherwise, try to fetch lyric online
    final res = await _lyricRepository.getLyric(
      trackName: songInfo.title,
      artistName: songInfo.artist,
      albumName: songInfo.album,
      duration: songInfo.duration ~/ 1000,
    );

    switch (res) {
      case Success<LrcLibResponse, CustomException>():
        final synced = res.value.syncedLyrics?.toString();
        final plain = res.value.plainLyrics?.toString();
        final content = synced ?? plain ?? '';

        // If no lyric found, update status to not found
        if (content.isEmpty) {
          emit(state.copyWith(status: LyricFinderStatus.notFound));
          return;
        }

        // If saving lyric to local DB fails, update status to not found
        final id = await _saveLyric(res.value);
        if (id == null) {
          emit(state.copyWith(status: LyricFinderStatus.notFound));
          return;
        }

        // Otherwise, emit the found lyric
        emit(
          state.copyWith(
            currentLrc: LrcBuilder().buildLrc(content),
            status: LyricFinderStatus.found,
          ),
        );

      case Failure<LrcLibResponse, CustomException>():
        emit(state.copyWith(status: LyricFinderStatus.notFound));
    }
  }

  void _onAutoFetchUpdated(
    _AutoFetchUpdated event,
    Emitter<LyricFinderState> emit,
  ) => emit(state.copyWith(isAutoFetch: event.isAutoFetch));

  Future<String?> _saveLyric(LrcLibResponse lrcResponse) async {
    final content =
        lrcResponse.syncedLyrics?.toString() ??
        lrcResponse.plainLyrics?.toString() ??
        '';
    if (content.isEmpty) return null;

    return _localDbService.saveLrc(
      title: lrcResponse.trackName,
      artist: lrcResponse.artistName,
      content: content,
    );
  }

  void _onReset(_Reset event, Emitter<LyricFinderState> emit) => emit(
    state.copyWith(
      targetMedia: null,
      currentLrc: null,
      status: LyricFinderStatus.initial,
    ),
  );
}
