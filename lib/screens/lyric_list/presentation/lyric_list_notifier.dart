import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/lyric_model.dart';
import '../../../services/db_helper.dart';
import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/lyric_file_processor.dart';
import '../../../v4/configs/routes/app_router.dart';
import '../domain/lyric_list_state.dart';
import 'lyric_list_filter_notifier.dart';

part 'lyric_list_notifier.g.dart';

@riverpod
class LyricListNotifier extends _$LyricListNotifier {
  @override
  Future<LyricListState> build() async {
    final searchTerm = ref.watch(
      lyricListFilterNotifierProvider.select((value) => value.searchTerm ?? ''),
    );

    final lyrics = await ref.read(allRawLyricsProvider.future);

    return LyricListState(
        lyrics: lyrics.where((element) {
      final fileName = element.fileName?.toLowerCase() ?? '';
      final artist = element.artist?.toLowerCase() ?? '';
      final title = element.title?.toLowerCase() ?? '';

      return fileName.contains(searchTerm) || artist.contains(searchTerm) || title.contains(searchTerm);
    }).toList());
  }

  Future<void> deleteLyric(LrcDB lrcDB) =>
      ref.read(dbHelperProvider).deleteLyric(lrcDB).then((_) => ref.invalidateSelf());

  Future<void> deleteAllLyrics() => ref.read(dbHelperProvider).deleteAllLyrics().then((_) => ref.invalidateSelf());

  Future<List<PlatformFile>> importFiles() async {
    final value = state.valueOrNull;
    if (value == null) return [];

    state = const AsyncLoading();

    final failed = await ref.read(lrcProcessorProvider).pickLrcFiles();

    ref.invalidateSelf();

    // if new lyric found for current song, update it
    ref.invalidate(lyricStateProvider);

    return failed;
  }

  Future<Object?> editLyric(LrcDB lyric) => ref.read(appRouterProvider).pushNamed(
        AppRoute.localLyricDetail.name,
        pathParameters: {'id': lyric.id.toString()},
      );
}
