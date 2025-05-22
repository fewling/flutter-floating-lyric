import 'package:isar/isar.dart';

import '../../models/lyric_model.dart';
import '../../utils/logger.dart';

class LocalDbRepo {
  LocalDbRepo(Isar isar) {
    _isar = isar;
  }

  late Isar _isar;

  Future<bool> fileNameExists(String fileName) async =>
      await _isar.lrcDBs.filter().fileNameEqualTo(fileName).count() > 0;

  Future<List<LrcDB>> get allRawLyrics => _isar.lrcDBs.where().findAll();

  Future<LrcDB?> getLyricByID(int id) {
    return _isar.lrcDBs.where().idEqualTo(id).findFirst();
  }

  Future<LrcDB?>? getLyric(String title, String artist) async {
    final result = await _isar.lrcDBs
        .filter()
        .fileNameEqualTo('$title - $artist', caseSensitive: false)
        .findFirst();
    if (result != null) return result;

    final resultReverse = await _isar.lrcDBs
        .filter()
        .fileNameEqualTo('$artist - $title', caseSensitive: false)
        .findFirst();
    if (resultReverse != null) return resultReverse;

    final allLyrics = await allRawLyrics;
    final hasLyric = allLyrics.any(
      (element) => element.title == title && element.artist == artist,
    );
    if (!hasLyric) return null;

    final lyric = allLyrics.firstWhere(
      (lyric) => lyric.title == title && lyric.artist == artist,
    );
    return lyric;
  }

  Future<List<LrcDB>> search(String searchTerm) async {
    final foundLyrics = <LrcDB>{};

    // final titleF = _isar.lrcDBs.where().filter().titleContains(searchTerm, caseSensitive: false).findAll();
    // final artistF = _isar.lrcDBs.where().filter().artistContains(searchTerm, caseSensitive: false).findAll();
    final filesF = _isar.lrcDBs
        .where()
        .filter()
        .fileNameContains(searchTerm, caseSensitive: false)
        .findAll();

    final results = await Future.wait([
      // titleF,
      // artistF,
      filesF,
    ]);

    for (final result in results) {
      foundLyrics.addAll(result);
    }

    return foundLyrics.toList();
  }

  Future<List<Id>> addBatchLyrics(List<LrcDB> lyrics) {
    logger.i('Adding batch lyrics: ${lyrics.length} lyrics');
    return _isar.writeTxn(() => _isar.lrcDBs.putAll(lyrics)).onError((
      error,
      stackTrace,
    ) {
      logger.e('Error adding batch lyrics: $error\nstacktrace: $stackTrace');
      return [-1];
    });
  }

  Future<bool> deleteLyric(LrcDB lyric) =>
      _isar.writeTxn(() => _isar.lrcDBs.delete(lyric.id));

  Future<void> deleteAllLyrics() => _isar.writeTxn(() => _isar.lrcDBs.clear());

  Future<Id> updateLyric(LrcDB lrc) {
    return _isar.writeTxn(() => _isar.lrcDBs.put(lrc)).onError((
      error,
      stackTrace,
    ) {
      logger.e('Error updating lyric: $error\nstacktrace: $stackTrace');
      return -1;
    });
  }

  Future<Id> putLyric(LrcDB lrcDB) {
    return _isar.writeTxn(() => _isar.lrcDBs.put(lrcDB));
  }
}
