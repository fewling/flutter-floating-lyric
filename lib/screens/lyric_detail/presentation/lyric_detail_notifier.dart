import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/db_helper.dart';
import '../domain/lrc_detail_state.dart';

part 'lyric_detail_notifier.g.dart';

@riverpod
class LyricDetailNotifier extends _$LyricDetailNotifier {
  @override
  Future<LyricDetailState> build({required String id}) async {
    final lrc = await ref.read(lyricByIDProvider(id: int.parse(id)).future);
    return LyricDetailState(lrcDB: lrc, originalContent: lrc?.content ?? '');
  }

  void updateContent(String value) {
    final current = state.valueOrNull;
    if (current == null) return;

    if (current.lrcDB == null) return;

    final newLrc = current.lrcDB!..content = value;
    state = AsyncData(current.copyWith(lrcDB: newLrc));
  }

  Future<Id> save() async {
    final current = state.valueOrNull;
    if (current == null) return -1;
    if (current.lrcDB == null) return -1;

    final id = await ref.read(dbHelperProvider).updateLyric(current.lrcDB!);

    final originalContent = current.lrcDB!.content;
    state = AsyncData(current.copyWith(originalContent: originalContent ?? ''));

    return id;
  }
}
