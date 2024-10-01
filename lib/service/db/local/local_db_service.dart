import 'package:isar/isar.dart';

import '../../../models/lyric_model.dart';
import '../../../services/db_helper.dart';

class LocalDbService {
  LocalDbService({
    required DBHelper dbHelper,
  }) : _dbHelper = dbHelper;

  final DBHelper _dbHelper;

  Future<void> saveLrc({
    required String title,
    required String artist,
    String? content,
  }) async {
    final lrcDB = LrcDB()
      ..fileName = '$title - $artist'
      ..title = title
      ..artist = artist
      ..content = content;
    await _dbHelper.putLyric(lrcDB);
  }

  Future<LrcDB?>? getLyric(String id) {
    final numId = int.tryParse(id);
    if (numId == null) return Future.value();

    return _dbHelper.getLyricByID(numId);
  }

  Future<List<LrcDB>> getAllLyrics() {
    return _dbHelper.allRawLyrics;
  }

  Future<List<LrcDB>> searchLyrics(String searchTerm) {
    return _dbHelper.search(searchTerm);
  }

  Future<Id> updateLrc(LrcDB lrcDb) {
    return _dbHelper.updateLyric(lrcDb);
  }

  Future<void> deleteLrc(LrcDB lrcDb) {
    return _dbHelper.deleteLyric(lrcDb);
  }

  Future<void> deleteAllLyrics() {
    return _dbHelper.deleteAllLyrics();
  }
}
