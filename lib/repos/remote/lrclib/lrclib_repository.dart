import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

import '../../../utils/logger.dart';

part 'lrclib_repository.freezed.dart';
part 'lrclib_repository.g.dart';
part 'lrclib_response.dart';

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
