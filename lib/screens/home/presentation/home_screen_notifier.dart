import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/floating_window/floating_window_notifier.dart';
import '../../../services/lyric_file_processor.dart';
import '../../../services/method_channels/floating_window_method_invoker.dart';
import '../../../services/method_channels/permission_method_invoker.dart';
import '../../../services/preferences/app_preference_notifier.dart';
import '../domain/home_state.dart';

part 'home_screen_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    ref.listen(
      lyricStateProvider.select((value) => value.mediaState),
      (prev, next) {
        if (prev == next) return;
        state = state.copyWith(mediaState: next);
      },
    );

    ref.listen(
      floatingWindowNotifierProvider.select((value) => value.isVisible),
      (prev, next) {
        if (prev == next) return;
        state = state.copyWith(isWindowVisible: next);
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
    ref.read(preferenceNotifierProvider.notifier).updateColor(value);
  }

  void updateWindowOpacity(double value) {
    ref.read(preferenceNotifierProvider.notifier).updateOpacity(value);
  }

  Future<List<PlatformFile>> importLRCs() async {
    state = state.copyWith(isProcessingFiles: true);
    final failed = await ref.read(lrcProcessorProvider).pickLrcFiles();

    state = state.copyWith(
      isProcessingFiles: false,
      mediaState: state.mediaState?.copyWith(
        title: '',
        artist: '',
        album: '',
      ),
    );

    // if new lyric found for current song, update it
    ref.invalidate(lyricStateProvider);

    return failed;
  }

  void start3rdMusicPlayer() {
    ref.read(permissionMethodInvokerProvider.notifier).start3rdMusicPlayer();
  }
}
