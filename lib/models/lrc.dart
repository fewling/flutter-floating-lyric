class Lrc {
  Lrc(String content) {
    final metadataExp = RegExp(r'\[(\w+):([^\]]+)\]');
    final timeExp = RegExp(r'\[(\d+):(\d+\.\d+)\]');
    lines = [];

    for (final String line in content.split('\n')) {
      if (line.trim().isEmpty) {
        continue;
      }

      if (timeExp.hasMatch(line)) {
        final match = timeExp.firstMatch(line)!;
        final minutes = int.tryParse(match.group(1)!) ?? 0;
        final seconds = double.tryParse(match.group(2)!) ?? 0;
        final time =
            Duration(minutes: minutes, milliseconds: (seconds * 1000).toInt());
        final text = line.replaceAll(timeExp, '').trim();
        lines.add(LrcLine(time, text));
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
  }
  String? artist;
  String? title;
  String? album;
  String? creator;
  String? author;
  String? program;
  String? version;
  late List<LrcLine> lines;
}

class LrcLine {
  LrcLine(this.time, this.line);
  Duration time;
  String line;
}
