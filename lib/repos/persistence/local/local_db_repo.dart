import 'package:collection/collection.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../models/lyric_model.dart';
import '../../../utils/logger.dart';

class LocalDbRepo {
  LocalDbRepo({required IsolatedBox<LrcModel> lrcBox}) : _lrcBox = lrcBox;

  final IsolatedBox<LrcModel> _lrcBox;

  Stream<BoxEvent> watch() => _lrcBox.watch();

  Future<bool> fileNameExists(String fileName) =>
      _lrcBox.values.then((items) => items.any((e) => e.fileName == fileName));

  Future<List<LrcModel>> get allRawLyrics =>
      _lrcBox.values.then((items) => items.toList());

  Future<LrcModel?> getLyricByID(dynamic id) => _lrcBox.get(id);

  Future<LrcModel?> getLyric(String title, String artist) =>
      _lrcBox.values.then(
        (items) => items.firstWhereOrNull(
          (e) =>
              (e.title == title && e.artist == artist) ||
              (e.title == artist && e.artist == title) ||
              (e.fileName == '$title - $artist') ||
              (e.fileName == '$artist - $title'),
        ),
      );

  Future<List<LrcModel>> search(String searchTerm) async {
    final search = searchTerm.toLowerCase().trim();
    final items = await _lrcBox.values;
    return items
        .where(
          (e) =>
              (e.title != null && e.title!.toLowerCase().contains(search)) ||
              (e.artist != null && e.artist!.toLowerCase().contains(search)) ||
              (e.fileName != null &&
                  e.fileName!.toLowerCase().contains(search)),
        )
        .toList();
  }

  Future<void> addBatchLyrics(List<LrcModel> lyrics) async {
    final entries = {for (final lyric in lyrics) lyric.id: lyric};
    logger.i('Adding batch lyrics: ${entries.length} lyrics');

    return _lrcBox.putAll(entries).onError((error, stackTrace) {
      logger.e('Error adding batch lyrics: $error\nstacktrace: $stackTrace');
    });
  }

  Future<void> deleteLyric(LrcModel lyric) => _lrcBox.delete(lyric.id);

  Future<int> deleteAllLyrics() => _lrcBox.clear();

  Future<void> updateLyric(LrcModel lrc) => _lrcBox.put(lrc.id, lrc);

  Future<void> putLyric(LrcModel lrcDB) => _lrcBox.put(lrcDB.id, lrcDB);
}
