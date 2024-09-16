import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/logger.dart';
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
    if (kDebugMode) logger.d('Getting lyric from LrcLib, url: $url');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      if (kDebugMode) logger.e('Failed to get lyric from LrcLib, response: ${response.body}');
      throw Exception('Could not find lyric');
    } else {
      // https://stackoverflow.com/a/71596683/13921129
      final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return LrcLibResponse.fromJson(json);
    }
  }
}
