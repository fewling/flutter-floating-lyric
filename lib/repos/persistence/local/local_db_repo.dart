import 'package:collection/collection.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../models/lyric_model.dart';
import '../../../utils/logger.dart';

class LocalDbRepo {
  LocalDbRepo({required Box<LrcModel> lrcBox}) : _lrcBox = lrcBox;

  final Box<LrcModel> _lrcBox;

  bool fileNameExists(String fileName) =>
      _lrcBox.values.any((e) => e.fileName == fileName);

  List<LrcModel> get allRawLyrics => _lrcBox.values.toList();

  LrcModel? getLyricByID(dynamic id) => _lrcBox.get(id);

  LrcModel? getLyric(String title, String artist) =>
      _lrcBox.values.firstWhereOrNull(
        (e) =>
            (e.title == title && e.artist == artist) ||
            (e.title == artist && e.artist == title) ||
            (e.fileName == '$title - $artist') ||
            (e.fileName == '$artist - $title'),
      );

  List<LrcModel> search(String searchTerm) {
    final search = searchTerm.toLowerCase().trim();
    return _lrcBox.values
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
