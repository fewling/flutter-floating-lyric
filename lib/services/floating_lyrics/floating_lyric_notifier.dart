import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lrc.dart';
import '../app_preference.dart';
import '../db_helper.dart';
import '../event_channels/media_states/media_state.dart';
import '../event_channels/media_states/media_state_event_channel.dart';
import '../lyric_file_processor.dart';
import '../platform_invoker.dart';
import 'floating_lyric_state.dart';

final lyricStateProvider =
    NotifierProvider<FloatingLyricNotifier, FloatingLyricState>(
        FloatingLyricNotifier.new);

class FloatingLyricNotifier extends Notifier<FloatingLyricState> {
  @override
  FloatingLyricState build() {
    mediaStateStream.listen(updateFromEventChannel);

    return const FloatingLyricState(currentStep: 0);
  }

  void updateStep(int value) => state = state.copyWith(currentStep: value);

  Future<void> toggleWindowVisibility() async {
    final nativeIsShowing =
        await ref.read(platformInvokerProvider).checkFloatingWindow();

    if (nativeIsShowing == null) return;

    final invoker = ref.read(platformInvokerProvider);
    if (!nativeIsShowing) {
      invoker.showFloatingWindow();
    } else if (nativeIsShowing) {
      invoker.closeFloatingWindow();
    }

    final isNativeShowingAfterToggle =
        await ref.read(platformInvokerProvider).checkFloatingWindow();
    state = state.copyWith(
        isFloatingWindowShown: isNativeShowingAfterToggle ?? false);
  }

  Future<void> updateFromEventChannel(List<MediaState> mediaStates) async {
    try {
      for (final mediaState in mediaStates) {
        if (!mediaState.isPlaying) continue;

        final title = mediaState.title;
        final artist = mediaState.artist;
        final position = mediaState.position;
        final duration = mediaState.duration;
        final isPlaying = mediaState.isPlaying;
        final currentLrc = state.currentLrc;

        final dbHelper = ref.read(dbHelperProvider);
        final isNewSong = state.title != title || state.artist != artist;

        if (isNewSong) {
          state = state.copyWith(
            title: title,
            artist: artist,
            position: position,
            duration: duration,
            isPlaying: isPlaying,
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
              state = state.copyWith(currentLine: line.line);
              break;
            }
          }
        } else if (currentLrc == null) {
          state = state.copyWith(currentLine: 'No Lyric Found');
        }
        break;
      }
    } catch (e) {
      Logger.e(e);
    }
  }

  Future<void> sendLyricToNative() async {
    final invoker = ref.read(platformInvokerProvider);

    final position = state.position;
    final lrc = state.currentLrc;

    if (lrc == null) {
      await invoker.updateFloatingWindow('No Lyric Found');
    } else {
      for (final line in lrc.lines.reversed) {
        if (position > line.time.inMilliseconds || line == lrc.lines.first) {
          invoker.updateFloatingWindow(line.line);
          break;
        }
      }
    }
  }

  Future<List<PlatformFile>> pickLyrics() async {
    state = state.copyWith(isProcessingFiles: true);
    final failed = await ref.read(lrcProcessorProvider).pickLrcFiles();

    state = state.copyWith(
      isProcessingFiles: false,
      artist: '',
      title: '',
      currentLrc: null,
    );
    return failed;
  }

  void updateWindowOpacity(double value) {
    ref.read(preferenceProvider.notifier).updateOpacity(value.ceilToDouble());
    ref.read(platformInvokerProvider).updateWindowOpacity();
  }

  void updateWindowColor(Color color) {
    ref.read(preferenceProvider.notifier).updateColor(color);
    ref.read(platformInvokerProvider).updateWindowColor();
  }
}
