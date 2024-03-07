import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/lyric_model.dart';
import '../../../services/db_helper.dart';
import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/floating_window/floating_window_notifier.dart';
import '../../../services/lrclib/data/lrclib_response.dart';
import '../../../services/lrclib/repo/lrclib_repository.dart';
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

  void toggleMillisVisibility(bool value) {
    ref.read(preferenceNotifierProvider.notifier).toggleShowMilliseconds();
  }

  void toggleProgressBarVisibility(bool value) {
    ref.read(preferenceNotifierProvider.notifier).toggleShowProgressBar();
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

  Future<LrcLibResponse?> fetchLyric() async {
    if (state.mediaState == null) throw Exception('No media state found');

    try {
      state = state.copyWith(isSearchingOnline: true);
      final response = await ref.read(
        lyricProvider(
          trackName: state.mediaState!.title,
          artistName: state.mediaState!.artist,
          albumName: state.mediaState!.album,
          duration: state.mediaState!.duration ~/ 1000,
        ).future,
      );
      state = state.copyWith(isSearchingOnline: false);

      return response;
    } catch (e) {
      state = state.copyWith(isSearchingOnline: false);
      return null;
    }
  }

  Future<Id> saveLyric(LrcLibResponse lrcResponse) async {
    final lrcDB = LrcDB()
      ..fileName = '${lrcResponse.trackName} - ${lrcResponse.artistName}'
      ..title = lrcResponse.trackName
      ..artist = lrcResponse.artistName
      ..content = lrcResponse.syncedLyrics;

    final id = await ref.read(dbHelperProvider).putLyric(lrcDB);

    // if new lyric found for current song, update it
    if (id >= 0) ref.invalidate(lyricStateProvider);

    return id;
  }
}
