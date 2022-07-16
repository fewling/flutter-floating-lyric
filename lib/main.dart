import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:floating_lyric/lyric.dart';
import 'package:floating_lyric/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.initFlutter().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _eventChannel = EventChannel('event_channel');
  late StreamSubscription _streamSubscription;
  final StreamController<Song> _songStreamController = StreamController();

  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;

  late Box _box;

  bool _isShowingWindow = false;
  bool _shouldShowWindow = false;
  bool _uiParamChanged = false;

  Song playingSong = Song();
  String displayingLyric = '';
  final List<Map<int, String>> _millisLyric = [];

  Color _textColor = Colors.deepPurple.shade300;

  double _backgroundOpcity = 0.0;

  @override
  void initState() {
    _requestPermissions();

    Hive.openBox('song_box').then((b) {
      _box = b;

      _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
          (event) => _songStreamController.add(Song.fromMap(event as Map)),
          onError: (error) => log('Received error: ${error.message}'),
          cancelOnError: true);

      _songStreamController.stream.listen((song) async {
        if (_shouldShowWindow) {
          _isShowingWindow ? updateWindow(song) : showWindow(song);
        }
      });
    });

    super.initState();
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void buildLyricList(Song song) {
    log('playingSong title: ${playingSong.title}, song title: ${song.title}');

    final artist = song.artist;
    final title = song.title;
    final key = '$artist - $title';
    _millisLyric.clear();

    log('box contains $key: ${_box.containsKey(key)}');

    if (!_box.containsKey(key)) return;
    final lyric = Lyric.fromMap((_box.get(key)) as Map);

    const pattern = r'[0-9]{2}:[0-9]{2}.[0-9]{2}';
    final regExp = RegExp(pattern);

    for (final line in lyric.content) {
      Iterable<RegExpMatch> matches = regExp.allMatches(line);

      for (final m in matches) {
        final l = m.input;

        final lastBracketIndex = l.lastIndexOf(']') + 1;
        final content = l.substring(lastBracketIndex);
        String time = l.substring(0, lastBracketIndex);

        while (time.contains(']')) {
          final index = time.indexOf(']') + 1;
          final t = time.substring(0, index);

          final minute = int.parse(t.substring(1, 3));
          final second = int.parse(t.substring(4, 6));
          final millis = int.parse(t.substring(7, 9));

          final millisTime = minute * 60 * 1000 + second * 1000 + millis;
          _millisLyric.add({millisTime: content});
          time = time.replaceRange(0, index, '');
        }
      }
    }

    _millisLyric.sort((a, b) => a.keys.first.compareTo(b.keys.first));

    log('millisLyric: $_millisLyric');
  }

  void showWindow(Song song) {
    log('showWindow');

    SystemWindowHeader header = SystemWindowHeader(
      padding: SystemWindowPadding.setSymmetricPadding(8, 8),
      title: SystemWindowText(
        text: '${song.artist} - ${song.title}',
        fontSize: 12,
        textColor: _textColor,
      ),
      decoration: SystemWindowDecoration(startColor: Colors.transparent),
    );
    SystemWindowBody body = SystemWindowBody(
      rows: [
        EachRow(
          columns: [
            EachColumn(
              text: SystemWindowText(
                  text: "...", fontSize: 12, textColor: Colors.black45),
            ),
          ],
          gravity: ContentGravity.CENTER,
        ),
      ],
      padding: SystemWindowPadding.setSymmetricPadding(8, 8),
      decoration: SystemWindowDecoration(startColor: Colors.transparent),
    );
    SystemAlertWindow.showSystemWindow(
      height: 150,
      header: header,
      body: body,
      gravity: SystemWindowGravity.TOP,
      prefMode: prefMode,
    ).then((showed) => _isShowingWindow = true);
  }

  void updateWindow(Song song) {
    // log('updateWindow');

    if (playingSong.title != song.title) {
      playingSong = song;
      buildLyricList(song);
    }

    final currentDuration = int.parse(song.currentDuration);

    String? content = 'No lyric';

    for (final lyric in _millisLyric.reversed) {
      final timeKey = lyric.keys.first;
      if (currentDuration >= timeKey - 500) {
        content = lyric[timeKey];
        break;
      }
    }

    if (displayingLyric != content && content != null ||
        _uiParamChanged && content != null) {
      displayingLyric = content;

      SystemWindowHeader header = SystemWindowHeader(
        padding: SystemWindowPadding.setSymmetricPadding(8, 8),
        title: SystemWindowText(
          text: '${song.artist} - ${song.title}',
          fontSize: 14,
          textColor: _textColor,
        ),
        decoration: SystemWindowDecoration(
            startColor: Colors.black.withOpacity(_backgroundOpcity)),
      );
      SystemWindowBody body = SystemWindowBody(
        rows: [
          EachRow(
            columns: [
              EachColumn(
                text: SystemWindowText(
                    text: content.isEmpty ? '...' : content,
                    fontSize: 20,
                    textColor: _textColor),
              ),
            ],
            gravity: ContentGravity.CENTER,
          ),
        ],
        padding: SystemWindowPadding.setSymmetricPadding(8, 8),
        decoration: SystemWindowDecoration(
            startColor: Colors.black.withOpacity(_backgroundOpcity)),
      );
      SystemAlertWindow.updateSystemWindow(
        height: 150,
        header: header,
        body: body,
        gravity: SystemWindowGravity.TOP,
        prefMode: prefMode,
      ).then((value) => _uiParamChanged = false);
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  String debugText = 'Test';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: MaterialPicker(
                pickerColor: _textColor,
                onColorChanged: (color) => setState(() {
                  _textColor = color;
                  _uiParamChanged = true;
                }),
                enableLabel: true, // only on portrait mode
                portraitOnly: true,
              ),
            ),
            Slider(
              label: _backgroundOpcity.toString(),
              divisions: 20,
              value: _backgroundOpcity,
              min: 0,
              max: 1,
              onChanged: (value) => setState(
                () {
                  _backgroundOpcity = value;
                  _uiParamChanged = true;
                },
              ),
            ),
            SwitchListTile(
              title: Text(_shouldShowWindow ? 'Visible' : 'Hidden'),
              value: _shouldShowWindow,
              onChanged: (value) {
                setState(() => _shouldShowWindow = value);

                if (!_shouldShowWindow) {
                  SystemAlertWindow.closeSystemWindow(prefMode: prefMode)
                      .then((value) => _isShowingWindow = false);
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => importLRC(),
                        label: const Text('Import LRC'),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => clearDB(),
                        label: const Text('Clear DB'),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearDB() {
    try {
      Hive.boxExists('song_box').then((exists) {
        if (exists) {
          Hive.openBox('song_box').then((box) => box.clear());
        }
      });
    } catch (e) {
      log('clearDB error: $e');
    }
  }

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

        if (fileExt.toLowerCase() == 'lrc') {
          File f = File(item.path);

          final singer = name.split('-').first;
          final song = name.split('-').last;
          final content = f.readAsLinesSync();

          final lyric = Lyric(singer: singer, song: song, content: content);

          box.put('$singer-$song', lyric.toJson());

          log('key: $singer-$song');
        }
      }
    }
  }

  Widget buildSongStreamer() {
    return Center(
      child: StreamBuilder<Song>(
        stream: _songStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Song song = snapshot.data!;
            return Text(
              '${song.title} - ${song.artist}',
              style: Theme.of(context).textTheme.headline4,
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.headline4,
            );
          } else {
            return const Text('Waiting for data...');
          }
        },
      ),
    );
  }
}
