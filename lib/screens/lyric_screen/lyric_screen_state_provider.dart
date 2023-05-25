// ignore_for_file: avoid_dynamic_calls

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lrc.dart';
import '../../services/app_preference.dart';
import '../../services/db_helper.dart';
import '../../services/lyric_file_processor.dart';
import '../../services/platform_invoker.dart';
import 'lyric_screen_state.dart';

final lyricStateProvider =
    NotifierProvider<LyricScreenStateNotifier, LyricScreenState>(
        LyricScreenStateNotifier.new);

class LyricScreenStateNotifier extends Notifier<LyricScreenState> {
  @override
  LyricScreenState build() => const LyricScreenState(currentStep: 0);

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

  Future<void> updateFromEventChannel(event) async {
    try {
      final mediaPlayerName = event['mediaPlayerName'] as String;
      final title = event['title'] as String;
      final artist = event['artist'] as String;
      final position = event['position'] as double;
      final duration = event['duration'] as double;
      final isPlaying = event['isPlaying'] as bool;
      final isShowing = event['isShowing'] as bool;
      // Logger.i('updateFromEventChannel: $event');

      final dbHelper = ref.read(dbHelperProvider);

      final isNewSong = state.title != title;
      final lrcDB = isNewSong ? await dbHelper.getLyric(title, artist) : null;
      final isLyricFound = lrcDB != null;

      if (isNewSong) {
        if (isLyricFound) {
          state = state.copyWith(
              mediaPlayerName: mediaPlayerName,
              title: title,
              artist: artist,
              position: position,
              duration: duration,
              isPlaying: isPlaying,
              isFloatingWindowShown: isShowing,
              currentLrc: Lrc(lrcDB.content ?? ''));
        } else {
          state = state.copyWith(
              mediaPlayerName: mediaPlayerName,
              title: title,
              artist: artist,
              position: position,
              duration: duration,
              isPlaying: isPlaying,
              isFloatingWindowShown: isShowing,
              currentLrc: null);
        }
      } else {
        if (state.isFloatingWindowShown == isShowing) {
          state = state.copyWith(
            mediaPlayerName: mediaPlayerName,
            title: title,
            artist: artist,
            position: position,
            duration: duration,
            isPlaying: isPlaying,
          );
        } else {
          state = state.copyWith(
            mediaPlayerName: mediaPlayerName,
            title: title,
            artist: artist,
            position: position,
            duration: duration,
            isPlaying: isPlaying,
            isFloatingWindowShown: isShowing,
          );
        }
      }

      if (isPlaying) sendLyricToNative();
    } catch (e) {
      Logger.e(e);
    }
  }

  void sendLyricToNative() {
    final invoker = ref.read(platformInvokerProvider);

    final position = state.position;
    final lrc = state.currentLrc;

    if (lrc == null) {
      invoker.updateFloatingWindow('No Lyric Found');
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
