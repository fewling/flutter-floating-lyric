import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/app_preference.dart';
import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/floating_window/floating_window_notifier.dart';
import '../../../services/lyric_file_processor.dart';
import '../../../services/method_channels/floating_window_method_invoker.dart';
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
      (prev, next) {
        final progress = next.seekBarProgress / next.seekBarMax;

        state = state.copyWith(
          isWindowVisible: next.isVisible,
          progress: progress.isInfinite || progress.isNaN ? 0.0 : progress,
        );
      },
    );

    return const HomeState();
  }

  void updateStep(int value) {
    state = state.copyWith(currentIndex: value);
  }

  void toggleWindow(bool value) {
    final invoker = ref.read(floatingWindowMethodInvokerProvider.notifier);

    // TODO: set to toggle
    if (value) {
      invoker.showFloatingWindow();
    } else {
      invoker.closeFloatingWindow();
    }
  }

  void updateWindowColor(Color value) {
    ref.read(preferenceProvider.notifier).updateColor(value);
  }

  void updateWindowOpacity(double value) {
    ref.read(preferenceProvider.notifier).updateOpacity(value);
  }

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
