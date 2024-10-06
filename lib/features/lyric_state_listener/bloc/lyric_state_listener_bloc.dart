import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

import '../../../configs/main_overlay/search_lyric_status.dart';
import '../../../models/lrc.dart';
import '../../../service/db/local/local_db_service.dart';
import '../../../service/permissions/permission_service.dart';
import '../../../services/event_channels/media_states/media_state.dart';
import '../../../services/event_channels/media_states/media_state_event_channel.dart';
import '../../../services/lrclib/data/lrclib_response.dart';
import '../../../services/lrclib/repo/lrclib_repository.dart';
import '../../../utils/logger.dart';
import '../../../utils/lrc_builder.dart';

part 'lyric_state_listener_bloc.freezed.dart';
part 'lyric_state_listener_bloc.g.dart';
part 'lyric_state_listener_event.dart';
part 'lyric_state_listener_state.dart';

class LyricStateListenerBloc extends Bloc<LyricStateListenerEvent, LyricStateListenerState> {
  LyricStateListenerBloc({
    required LocalDbService localDbService,
    required LrcLibRepository lyricRepository,
    required PermissionService permissionService,
  })  : _localDbService = localDbService,
        _lyricRepository = lyricRepository,
        _permissionService = permissionService,
        super(const LyricStateListenerState()) {
    on<LyricStateListenerEvent>(
      (event, emit) => switch (event) {
        LyricStateListenerLoaded() => _onLoaded(event, emit),
        AutoFetchUpdated() => _onAutoFetchUpdated(event, emit),
        ShowLine2Updated() => _onShowLine2Updated(event, emit),
        StartMusicPlayerRequested() => _onMusicPlayerRequested(event, emit),
        NewLyricSaved() => _onNewLyricSaved(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;
  final PermissionService _permissionService;

  // TODO(@fewling): replace with remote lrc_lib_service
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
              searchLyricStatus: SearchLyricStatus.initial,
            ));

            final lrcDB = await _localDbService.getLyricBySongInfo(title, artist);
            final isLyricFound = lrcDB != null;
            if (isLyricFound) {
              logger.t('Lyric found in db: ${lrcDB.fileName}');
              emit(state.copyWith(
                currentLrc: LrcBuilder().buildLrc(lrcDB.content ?? ''),
                searchLyricStatus: SearchLyricStatus.found,
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
              if (success) {
                emit(state.copyWith(
                  searchLyricStatus: SearchLyricStatus.found,
                ));
                break;
              } else {
                emit(state.copyWith(
                  searchLyricStatus: SearchLyricStatus.notFound,
                ));
              }
            } else {
              emit(state.copyWith(
                searchLyricStatus: SearchLyricStatus.notFound,
              ));
            }
          } else if (currentLrc != null) {
            if (currentLrc.lines.isEmpty) {
              emit(state.copyWith(
                line1: null,
                line2: null,
                searchLyricStatus: SearchLyricStatus.empty,
                mediaState: state.mediaState?.copyWith(
                  position: position,
                  duration: duration,
                ),
              ));
              break;
            }

            if (state.showLine2) {
              var line1 = state.line1;
              var line2 = state.line2;

              if (state.line1 == null && state.line2 == null) {
                line1 = currentLrc.lines.first;
                line2 = currentLrc.lines.elementAtOrNull(1);
              } else {
                for (var i = 0; i < currentLrc.lines.length; i++) {
                  if (line1 == null) break;
                  if (line2 == null) break;

                  final line1Index = currentLrc.lines.indexOf(line1);
                  final line2Index = currentLrc.lines.indexOf(line2);
                  if (line1Index < 0 || line2Index < 0) break;

                  final lineAfterLine1 = currentLrc.lines.elementAtOrNull(line1Index + 1);
                  if (lineAfterLine1 != null) {
                    if (position > lineAfterLine1.time.inMilliseconds) {
                      line1 = currentLrc.lines.elementAtOrNull(line1Index + 2);
                    }
                  }

                  final lineAfterLine2 = currentLrc.lines.elementAtOrNull(line2Index + 1);
                  if (lineAfterLine2 != null) {
                    if (position > lineAfterLine2.time.inMilliseconds) {
                      line2 = currentLrc.lines.elementAtOrNull(line2Index + 2);
                    }
                  }
                }
              }

              emit(state.copyWith(
                line1: line1,
                line2: line2,
                mediaState: state.mediaState?.copyWith(
                  position: position,
                  duration: duration,
                ),
              ));
            } else {
              final reversed = currentLrc.lines.reversed.toList();
              for (final line in reversed) {
                if (position > line.time.inMilliseconds || line == currentLrc.lines.first) {
                  emit(state.copyWith(
                    line1: line,
                    mediaState: state.mediaState?.copyWith(
                      position: position,
                      duration: duration,
                    ),
                  ));
                  break;
                }
              }
            }
          } else if (currentLrc == null) {
            emit(state.copyWith(
              line1: null,
              line2: null,
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
      line1: null,
      line2: null,
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
        line1: const LrcLine(
          time: Duration.zero,
          content: 'Searching Online...',
        ),
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

      final lrcDB = await _localDbService.getLyricById(id.toString());
      emit(state.copyWith(
        currentLrc: LrcBuilder().buildLrc(lrcDB?.content ?? ''),
        searchLyricStatus: SearchLyricStatus.found,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSearchingOnline: false,
        searchLyricStatus: SearchLyricStatus.notFound,
      ));
      return false;
    }
  }

  Future<Id> saveLyric(LrcLibResponse lrcResponse) async {
    final content = lrcResponse.syncedLyrics?.toString() ?? lrcResponse.plainLyrics?.toString() ?? '';
    if (content.isEmpty) return -1;

    final id = await _localDbService.saveLrc(
      title: lrcResponse.trackName,
      artist: lrcResponse.artistName,
      content: content,
    );
    return id;
  }

  void _onMusicPlayerRequested(StartMusicPlayerRequested event, Emitter<LyricStateListenerState> emit) {
    _permissionService.start3rdMusicPlayer();
  }

  void _onNewLyricSaved(NewLyricSaved event, Emitter<LyricStateListenerState> emit) {
    emit(const LyricStateListenerState());
  }
}
