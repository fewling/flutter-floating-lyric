import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lrc.dart';
import '../db_helper.dart';
import '../event_channels/media_states/media_state.dart';
import '../event_channels/media_states/media_state_event_channel.dart';
import 'floating_lyric_state.dart';

final lyricStateProvider =
    NotifierProvider<FloatingLyricNotifier, FloatingLyricState>(
        FloatingLyricNotifier.new);

class FloatingLyricNotifier extends Notifier<FloatingLyricState> {
  @override
  FloatingLyricState build() {
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
        final duration = mediaState.duration;
        final currentLrc = state.currentLrc;

        final dbHelper = ref.read(dbHelperProvider);
        final isNewSong = state.mediaState?.title != title ||
            state.mediaState?.artist != artist;

        if (isNewSong) {
          state = state.copyWith(
            mediaState: mediaState,
            currentLrc: null,
          );

          final lrcDB = await dbHelper.getLyric(title, artist);
          final isLyricFound = lrcDB != null;
          if (isLyricFound) {
            state = state.copyWith(
              currentLrc: Lrc(lrcDB.content ?? ''),
            );
          }
        } else if (currentLrc != null) {
          for (final line in currentLrc.lines.reversed) {
            if (position > line.time.inMilliseconds ||
                line == currentLrc.lines.first) {
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
        break;
      }
    } catch (e) {
      Logger.e(e);
    }
  }
}
