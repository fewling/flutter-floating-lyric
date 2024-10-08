import 'package:isar/isar.dart';

import '../../../models/lyric_model.dart';
import '../../../repos/local/local_db_repo.dart';

class LocalDbService {
  LocalDbService({
    required LocalDbRepo localDBRepo,
  }) : _localDB = localDBRepo;

  final LocalDbRepo _localDB;

  Future<int> saveLrc({
    required String title,
    required String artist,
    String? content,
  }) async {
    final lrcDB = LrcDB()
      ..fileName = '$title - $artist'
      ..title = title
      ..artist = artist
      ..content = content;
    return _localDB.putLyric(lrcDB);
  }

  Future<LrcDB?>? getLyricById(String id) {
    final numId = int.tryParse(id);
    if (numId == null) return Future.value();

    return _localDB.getLyricByID(numId);
  }

  Future<LrcDB?>? getLyricBySongInfo(String title, String artist) {
    return _localDB.getLyric(title, artist);
  }

  Future<List<LrcDB>> getAllLyrics() {
    return _localDB.allRawLyrics;
  }

  Future<List<LrcDB>> searchLyrics(String searchTerm) {
    return _localDB.search(searchTerm);
  }

  Future<Id> updateLrc(LrcDB lrcDb) {
    return _localDB.updateLyric(lrcDb);
  }

  Future<void> deleteLrc(LrcDB lrcDb) {
    return _localDB.deleteLyric(lrcDb);
  }

  Future<void> deleteAllLyrics() {
    return _localDB.deleteAllLyrics();
  }
}
