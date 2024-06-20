import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../models/lrc.dart';
import '../../models/lyric_model.dart';
import '../db_helper.dart';
import '../event_channels/media_states/media_state.dart';
import '../event_channels/media_states/media_state_event_channel.dart';
import '../lrclib/data/lrclib_response.dart';
import '../lrclib/repo/lrclib_repository.dart';
import '../preferences/app_preference_notifier.dart';
import 'floating_lyric_state.dart';

final lyricStateProvider =
    NotifierProvider<FloatingLyricNotifier, FloatingLyricState>(FloatingLyricNotifier.new);

class FloatingLyricNotifier extends Notifier<FloatingLyricState> {
  late bool _autoFetchOnline;

  @override
  FloatingLyricState build() {
    _autoFetchOnline = ref.read(
      preferenceNotifierProvider.select((value) => value.autoFetchOnline),
    );

    ref.listen(
      preferenceNotifierProvider.select((value) => value.autoFetchOnline),
      (prev, next) {
        _autoFetchOnline = next;
        if (_autoFetchOnline && state.currentLrc == null) {
          final title = state.mediaState?.title;
          final artist = state.mediaState?.artist;
          final album = state.mediaState?.album;
          final duration = state.mediaState?.duration;

          if (title == null && artist == null) return;
          if (album == null) return;
          if (duration == null || duration <= 0) return;

          hasLyric(title!, artist!).then((hasLyric) {
            if (hasLyric) return;
            fetchLyric(title, artist, album, duration);
          });
        }
      },
    );

    mediaStateStream.listen(updateFromEventChannel);
    return const FloatingLyricState();
  }

  Future<void> updateFromEventChannel(List<MediaState> mediaStates) async {
    try {
      for (final mediaState in mediaStates) {
        if (!mediaState.isPlaying) continue;

        final title = mediaState.title;
        final artist = mediaState.artist;
        final position = mediaState.position;
        final album = mediaState.album;
        final duration = mediaState.duration;
        final currentLrc = state.currentLrc;
        if (duration <= 0) continue;

        final dbHelper = ref.read(dbHelperProvider);
        final isNewSong = state.mediaState?.title != title || state.mediaState?.artist != artist;

        if (isNewSong) {
          state = state.copyWith(
            mediaState: mediaState,
            currentLrc: null,
          );

          final lrcDB = await dbHelper.getLyric(title, artist);
          final isLyricFound = lrcDB != null;
          if (isLyricFound) {
            state = state.copyWith(currentLrc: Lrc(lrcDB.content ?? ''));
            break;
          } else if (_autoFetchOnline) {
            final success = await fetchLyric(title, artist, album, duration);
            if (success) break;
          }
        } else if (currentLrc != null) {
          for (final line in currentLrc.lines.reversed) {
            if (position > line.time.inMilliseconds || line == currentLrc.lines.first) {
              state = state.copyWith(
                currentLine: line.line,
                mediaState: state.mediaState?.copyWith(
                  position: position,
                  duration: duration,
                ),
              );
              break;
            }
          }
        } else if (currentLrc == null) {
          state = state.copyWith(
            currentLine: 'No Lyric Found',
            mediaState: state.mediaState?.copyWith(
              position: position,
              duration: duration,
            ),
          );
        }
      }
    } catch (e) {
      Logger.e(e);
    }
  }

  Future<bool> hasLyric(String title, String artist) async {
    final dbHelper = ref.read(dbHelperProvider);
    final lrcDB = await dbHelper.getLyric(title, artist);
    return lrcDB != null;
  }

  Future<bool> fetchLyric(String title, String artist, String album, double duration) async {
    if (state.mediaState == null) return false;

    try {
      state = state.copyWith(isSearchingOnline: true);
      final response = await ref.read(
        lyricProvider(
          trackName: title,
          artistName: artist,
          albumName: album,
          duration: duration ~/ 1000,
        ).future,
      );
      state = state.copyWith(isSearchingOnline: false);
      final synced = response.syncedLyrics?.toString();
      final plain = response.plainLyrics?.toString();
      final content = synced ?? plain ?? '';
      if (content.isEmpty) return false;

      final id = await saveLyric(response);
      if (id < 0) return false;

      final dbHelper = ref.read(dbHelperProvider);
      final lrcDB = await dbHelper.getLyricByID(id);
      state = state.copyWith(currentLrc: Lrc(lrcDB?.content ?? ''));

      return true;
    } catch (e) {
      state = state.copyWith(isSearchingOnline: false);
      return false;
    }
  }

  Future<Id> saveLyric(LrcLibResponse lrcResponse) async {
    final content =
        lrcResponse.syncedLyrics?.toString() ?? lrcResponse.plainLyrics?.toString() ?? '';
    if (content.isEmpty) return -1;

    final lrcDB = LrcDB()
      ..fileName = '${lrcResponse.trackName} - ${lrcResponse.artistName}'
      ..title = lrcResponse.trackName
      ..artist = lrcResponse.artistName
      ..content = content;

    final id = await ref.read(dbHelperProvider).putLyric(lrcDB);
    return id;
  }
}
