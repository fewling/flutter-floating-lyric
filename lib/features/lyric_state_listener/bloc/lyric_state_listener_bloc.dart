import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

import '../../../models/lrc.dart';
import '../../../models/lrc_builder.dart';
import '../../../models/lyric_model.dart';
import '../../../services/db_helper.dart';
import '../../../services/event_channels/media_states/media_state.dart';
import '../../../services/event_channels/media_states/media_state_event_channel.dart';
import '../../../services/lrclib/data/lrclib_response.dart';
import '../../../services/lrclib/repo/lrclib_repository.dart';
import '../../../utils/logger.dart';

part 'lyric_state_listener_bloc.freezed.dart';
part 'lyric_state_listener_bloc.g.dart';
part 'lyric_state_listener_event.dart';
part 'lyric_state_listener_state.dart';

class LyricStateListenerBloc extends Bloc<LyricStateListenerEvent, LyricStateListenerState> {
  LyricStateListenerBloc({
    required DBHelper dbHelper,
    required LrcLibRepository lyricRepository,
  })  : _dbHelper = dbHelper,
        _lyricRepository = lyricRepository,
        super(const LyricStateListenerState()) {
    on<LyricStateListenerEvent>(
      (event, emit) => switch (event) {
        LyricStateListenerLoaded() => _onLoaded(event, emit),
        AutoFetchUpdated() => _onAutoFetchUpdated(event, emit),
        ShowLine2Updated() => _onShowLine2Updated(event, emit),
      },
    );
  }

  // TODO(@fewling): replace with db service
  final DBHelper _dbHelper;
  final LrcLibRepository _lyricRepository;

  Future<void> _onLoaded(LyricStateListenerLoaded event, Emitter<LyricStateListenerState> emit) async {
    emit(state.copyWith(
      isAutoFetch: event.isAutoFetch,
      showLine2: event.showLine2,
    ));

    await emit.onEach(
      mediaStateStream,
      onData: (mediaStates) async {
        for (final mediaState in mediaStates) {
          if (!mediaState.isPlaying) continue;

          final title = mediaState.title;
          final artist = mediaState.artist;
          final position = mediaState.position;
          final album = mediaState.album;
          final duration = mediaState.duration;
          final currentLrc = state.currentLrc;
          if (duration <= 0) continue;

          final isNewSong = state.mediaState?.title != title || state.mediaState?.artist != artist;

          if (isNewSong) {
            emit(state.copyWith(
              mediaState: mediaState,
              currentLrc: null,
              line1: null,
              line2: null,
            ));

            final lrcDB = await _dbHelper.getLyric(title, artist);
            final isLyricFound = lrcDB != null;
            if (isLyricFound) {
              logger.t('Lyric found in db: ${lrcDB.fileName}');
              emit(state.copyWith(
                currentLrc: LrcBuilder().buildLrc(lrcDB.content ?? ''),
              ));

              break;
            } else if (state.isAutoFetch) {
              logger.t('Lyric not found in db, fetching online');
              final success = await _fetchLyric(
                emit,
                title: title,
                artist: artist,
                album: album,
                duration: duration,
              );

              logger.t('Lyric fetch success: $success');
              if (success) break;
            }
          } else if (currentLrc != null) {
            for (final line in currentLrc.lines.reversed) {
              if (position > line.time.inMilliseconds || line == currentLrc.lines.first) {
                emit(state.copyWith(
                  line1: line.content,
                  mediaState: state.mediaState?.copyWith(
                    position: position,
                    duration: duration,
                  ),
                ));
                break;
              }
            }
          } else if (currentLrc == null) {
            emit(state.copyWith(
              line1: state.isSearchingOnline ? 'Searching Online...' : 'No lyric found',
              mediaState: state.mediaState?.copyWith(
                position: position,
                duration: duration,
              ),
            ));
          }
        }
      },
    );
  }

  void _onAutoFetchUpdated(AutoFetchUpdated event, Emitter<LyricStateListenerState> emit) {
    emit(state.copyWith(
      isAutoFetch: event.isAutoFetch,
    ));
  }

  void _onShowLine2Updated(ShowLine2Updated event, Emitter<LyricStateListenerState> emit) {
    emit(state.copyWith(
      showLine2: event.showLine2,
    ));
  }

  Future<bool> _fetchLyric(
    Emitter<LyricStateListenerState> emit, {
    required String title,
    required String artist,
    required String album,
    required double duration,
  }) async {
    if (state.mediaState == null) return false;

    try {
      emit(state.copyWith(
        isSearchingOnline: true,
        line1: 'Searching Online...',
      ));

      final response = await _lyricRepository.getLyric(
        trackName: title,
        artistName: artist,
        albumName: album,
        duration: duration ~/ 1000,
      );

      emit(state.copyWith(isSearchingOnline: false));

      final synced = response.syncedLyrics?.toString();
      final plain = response.plainLyrics?.toString();
      final content = synced ?? plain ?? '';
      if (content.isEmpty) return false;

      final id = await saveLyric(response);
      if (id < 0) return false;

      final lrcDB = await _dbHelper.getLyricByID(id);
      emit(state.copyWith(
        currentLrc: LrcBuilder().buildLrc(lrcDB?.content ?? ''),
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSearchingOnline: false,
      ));
      return false;
    }
  }

  // TODO(@fewling): Replace with db service
  Future<Id> saveLyric(LrcLibResponse lrcResponse) async {
    final content = lrcResponse.syncedLyrics?.toString() ?? lrcResponse.plainLyrics?.toString() ?? '';
    if (content.isEmpty) return -1;

    final lrcDB = LrcDB()
      ..fileName = '${lrcResponse.trackName} - ${lrcResponse.artistName}'
      ..title = lrcResponse.trackName
      ..artist = lrcResponse.artistName
      ..content = content;

    final id = await _dbHelper.putLyric(lrcDB);
    return id;
  }
}
