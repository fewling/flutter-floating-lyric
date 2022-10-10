import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import '../models/lyric.dart';

class SongBox {
  // singleton constructor
  factory SongBox() => _instance;
  static final SongBox _instance = SongBox._();
  SongBox._();

  // properties
  Box? _songBox;
  final String _boxName = 'song_box';

  int get size => _songBox!.length;

  Future<void> openBox() =>
      Hive.openBox(_boxName).then((box) => _songBox = box);

  bool hasKey(String key) => _songBox!.containsKey(key);

  bool hasSong(String artist, String title) => hasKey('$artist - $title');

  Map getSongMap(String key) => _songBox!.get(key) as Map;

  String getTitleByIndex(int index) => _songBox!.keyAt(index).toString();

  // methods:
  Future<int> clearDB() => _songBox!.clear();

  Future<void> importLRC() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) return;

    log("Selected directory: $selectedDirectory");

    final List<FileSystemEntity> entities =
        Directory(selectedDirectory).listSync().toList();

    final box = await Hive.openBox('song_box');
    for (var item in entities) {
      if (item is File) {
        final fileNameWithExt = item.path.split('/').last;
        final name = fileNameWithExt.split('.').first;
        final fileExt = fileNameWithExt.split('.').last;

        if (fileExt.toLowerCase() == 'lrc' && name.contains('-')) {
          File f = File(item.path);
          final singer = name.split('-').first;
          final song = name.split('-').last;
          final content = f.readAsLinesSync();

          final lyric = Lyric(singer: singer, song: song, content: content);

          log('key: $singer-$song');
          box.put('$singer-$song', lyric.toJson());
        }
      }
    }
  }
}
