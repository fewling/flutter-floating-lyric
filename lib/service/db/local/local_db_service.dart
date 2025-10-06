import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../../models/lyric_model.dart';
import '../../../repos/local/local_db_repo.dart';

class LocalDbService {
  LocalDbService({required LocalDbRepo localDBRepo}) : _localDB = localDBRepo;

  final LocalDbRepo _localDB;

  Future<String> saveLrc({
    required String title,
    required String artist,
    String? content,
  }) async {
    final digest = sha256.convert(utf8.encode('$title$artist$content'));
    final id = digest.toString();
    final lrcDB = LrcModel(
      id: id,
      fileName: '$title - $artist',
      title: title,
      artist: artist,
      content: content,
    );
    await _localDB.putLyric(lrcDB);
    return id;
  }

  LrcModel? getLyricById(String id) => _localDB.getLyricByID(id);

  LrcModel? getLyricBySongInfo(String title, String artist) =>
      _localDB.getLyric(title, artist);

  List<LrcModel> getAllLyrics() => _localDB.allRawLyrics;

  List<LrcModel> searchLyrics(String searchTerm) => _localDB.search(searchTerm);

  Future<void> updateLrc(LrcModel lrcDb) => _localDB.updateLyric(lrcDb);

  Future<void> deleteLrc(LrcModel lrcDb) => _localDB.deleteLyric(lrcDb);

  Future<int> deleteAllLyrics() => _localDB.deleteAllLyrics();
}
