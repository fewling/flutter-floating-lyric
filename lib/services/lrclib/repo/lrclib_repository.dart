import 'dart:convert';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/lrclib_response.dart';

part 'lrclib_repository.g.dart';

@riverpod
LrcLibRepository lrcLibRepository(LrcLibRepositoryRef ref) {
  return LrcLibRepository();
}

@riverpod
FutureOr<LrcLibResponse> lyric(
  LyricRef ref, {
  required String trackName,
  required String artistName,
  required String albumName,
  required int duration,
}) {
  return ref.watch(lrcLibRepositoryProvider).getLyric(
        trackName: trackName,
        artistName: artistName,
        albumName: albumName,
        duration: duration,
      );
}

class LrcLibRepository {
  static const _baseUrl = 'https://lrclib.net/api';

  Future<LrcLibResponse> getLyric({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  }) async {
    final url = Uri.parse('$_baseUrl/get?'
        'track_name=$trackName'
        '&artist_name=$artistName'
        '&album_name=$albumName'
        '&duration=$duration');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      Logger.e('Failed to get lyric from LrcLib');
      throw Exception('Could not find lyric');
    } else {
      Logger.d('Got lyric from LrcLib');
      final body = response.body;
      final json = jsonDecode(body) as Map<String, dynamic>;
      return LrcLibResponse.fromJson(json);
    }
  }
}
