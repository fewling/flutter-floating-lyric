import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../models/lyric_model.dart';

final dbHelperProvider = Provider<DBHelper>((_) => throw UnimplementedError());

final allRawLyricsProvider =
    FutureProvider.autoDispose<List<LrcDB>>((ref) async {
  final dbHelper = ref.watch(dbHelperProvider);
  return dbHelper.allRawLyrics;
});

final lyricExistsProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, fileName) async {
  final dbHelper = ref.watch(dbHelperProvider);
  return dbHelper.fileNameExists(fileName);
});

class DBHelper {
  DBHelper(Isar isar) {
    _isar = isar;
  }

  late Isar _isar;

  Future<bool> fileNameExists(String fileName) async =>
      await _isar.lrcDBs.filter().fileNameEqualTo(fileName).count() > 0;

  Future<List<LrcDB>> get allRawLyrics => _isar.lrcDBs.where().findAll();

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
}
