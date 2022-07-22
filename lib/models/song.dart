class Song {
  late String title;
  late String artist;
  late String maxDuration;
  late String currentDuration;

  Song() {
    title = '';
    artist = '';
    maxDuration = '';
    currentDuration = '';
  }

  Song.fromMap(Map data) {
    title = data["song"] ?? "";
    artist = data["singer"] ?? "";
    maxDuration = data["max_duration"] ?? "";
    currentDuration = data["current_duration"] ?? "";
  }

  @override
  String toString() {
    return 'Song{title: $title, artist: $artist, maxDuration: $maxDuration, currentDuration: $currentDuration}';
  }
}
