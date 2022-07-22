class Lyric {
  late String singer;
  late String song;
  late List<String> content;

  Lyric({
    required this.singer,
    required this.song,
    required this.content,
  });

  Lyric.fromMap(Map map) {
    singer = map['singer'] ?? '';
    song = map['song'] ?? '';
    content = map['content'] ?? [];
  }

  @override
  String toString() {
    return 'Lyric{singer: $singer, song: $song, content: $content}';
  }

  toJson() {
    return {
      "singer": singer,
      "song": song,
      "content": content,
    };
  }
}
