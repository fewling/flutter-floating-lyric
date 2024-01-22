import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/lyric_model.dart';

part 'db_helper.g.dart';

@Riverpod(keepAlive: true)
DBHelper dbHelper(DbHelperRef ref) => throw UnimplementedError();

@riverpod
FutureOr<List<LrcDB>> allRawLyrics(AllRawLyricsRef ref) {
  return ref.watch(dbHelperProvider).allRawLyrics;
}

@riverpod
FutureOr<LrcDB?> lyricByID(LyricByIDRef ref, {required int id}) {
  return ref.watch(dbHelperProvider).getLyricByID(id);
}

@riverpod
FutureOr<bool> lyricExists(LyricExistsRef ref, {required String fileName}) {
  return ref.watch(dbHelperProvider).fileNameExists(fileName);
}

class DBHelper {
  DBHelper(Isar isar) {
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
        .fileNameEqualTo('$title - $artist')
        .findFirst();
    if (result != null) return result;

    final resultReverse = await _isar.lrcDBs
        .filter()
        .fileNameEqualTo('$artist - $title')
        .findFirst();
    if (resultReverse != null) return resultReverse;

    final allLyrics = await allRawLyrics;
    final hasLyric = allLyrics
        .any((element) => element.title == title && element.artist == artist);
    if (!hasLyric) return null;

    final lyric = allLyrics
        .firstWhere((lyric) => lyric.title == title && lyric.artist == artist);
    return lyric;
  }

  Future<List<Id>> addBatchLyrics(List<LrcDB> lyrics) {
    Logger.i('Adding batch lyrics: ${lyrics.length} lyrics');
    return _isar
        .writeTxn(() => _isar.lrcDBs.putAll(lyrics))
        .onError((error, stackTrace) {
      Logger.e('Error adding batch lyrics: $error\nstacktrace: $stackTrace');
      return [-1];
    });
  }

  Future<bool> deleteLyric(LrcDB lyric) =>
      _isar.writeTxn(() => _isar.lrcDBs.delete(lyric.id));

  Future<void> deleteAllLyrics() => _isar.writeTxn(() => _isar.lrcDBs.clear());

  Future<Id> updateLyric(LrcDB lrc) {
    return _isar
        .writeTxn(() => _isar.lrcDBs.put(lrc))
        .onError((error, stackTrace) {
      Logger.e('Error updating lyric: $error\nstacktrace: $stackTrace');
      return -1;
    });
  }
}
