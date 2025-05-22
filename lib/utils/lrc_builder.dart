import '../models/lrc.dart';

class LrcBuilder {
  // Factory constructor to return the static instance
  factory LrcBuilder() => _instance;

  // Private constructor
  LrcBuilder._();

  // Static instance of the class
  static final LrcBuilder _instance = LrcBuilder._();

  Lrc buildLrc(String content) {
    final metadataExp = RegExp(r'\[(\w+):([^\]]+)\]');
    final timeExp = RegExp(r'\[(\d+):(\d+\.\d+)\]');
    final lines = <LrcLine>[];

    String? artist;
    String? title;
    String? album;
    String? creator;
    String? author;
    String? program;
    String? version;

    for (final line in content.split('\n')) {
      if (line.trim().isEmpty) continue;

      if (timeExp.hasMatch(line)) {
        final match = timeExp.firstMatch(line)!;
        final minutes = int.tryParse(match.group(1)!) ?? 0;
        final seconds = double.tryParse(match.group(2)!) ?? 0;
        final time = Duration(
          minutes: minutes,
          milliseconds: (seconds * 1000).toInt(),
        );
        final text = line.replaceAll(timeExp, '').trim();
        lines.add(LrcLine(time: time, content: text));
      } else if (metadataExp.hasMatch(line)) {
        final match = metadataExp.firstMatch(line)!;
        final key = match.group(1)!;
        final value = match.group(2)!;

        switch (key) {
          case 'ar':
            artist = value;
            break;
          case 'ti':
            title = value;
            break;
          case 'al':
            album = value;
            break;
          case 'by':
            author = value;
            break;
          case 're':
            creator = value;
            break;
          case 've':
            version = value;
            break;
          case 'pr':
            program = value;
            break;
        }
      }
    }

    return Lrc(
      artist: artist,
      title: title,
      album: album,
      creator: creator,
      author: author,
      lines: lines,
      program: program,
      version: version,
    );
  }
}
