// ignore_for_file: avoid_dynamic_calls

import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/floating_window/floating_window_notifier.dart';
import '../../../services/lyric_file_processor.dart';
import '../domain/home_state.dart';

part 'home_screen_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    ref.listen(
      lyricStateProvider,
      (_, next) {
        final progress = next.position / next.duration;

        state = state.copyWith(
          isPlaying: next.isPlaying,
          title: next.title,
          artist: next.artist,
          mediaAppName: next.mediaPlayerName,
          progress: progress.isFinite || progress.isNaN ? progress : 0.0,
        );
      },
    );

    ref.listen(
      floatingWindowNotifierProvider,
      (_, next) {
        state = state.copyWith(isWindowVisible: next.isVisible);
      },
    );

    return const HomeState();
  }

  void updateStep(int value) {
    state = state.copyWith(currentIndex: value);
  }

  void toggleWindow(bool value) {
    // TODO
  }

  void updateWindowColor(Color value) {
    // TODO
  }

  void updateWindowOpacity(double value) {}

  Future<List<PlatformFile>> importLRCs() async {
    state = state.copyWith(isProcessingFiles: true);
    final failed = await ref.read(lrcProcessorProvider).pickLrcFiles();

    state = state.copyWith(
      isProcessingFiles: false,
      artist: '',
      title: '',
    );
    return failed;
  }
}
