import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:floating_lyric/lyric.dart';
import 'package:floating_lyric/song.dart';
import 'package:floating_lyric/window_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:system_alert_window/system_alert_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _eventChannel = EventChannel('event_channel');
  late StreamSubscription _streamSubscription;
  final StreamController<Song> _songStreamController = StreamController();
  final WindowController _windowController = WindowController();

  @override
  void initState() {
    Get.put(_windowController);

    SystemAlertWindow.requestPermissions(
        prefMode: SystemWindowPrefMode.OVERLAY);

    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
        (data) => _songStreamController.add(Song.fromMap(data as Map)),
        onError: (error) => log('Received error: ${error.message}'),
        cancelOnError: true);

    _songStreamController.stream
        .listen((song) => _windowController.song = song);

    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _songStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //* Color picker:
            Expanded(
              child: Obx(() => MaterialPicker(
                    pickerColor: _windowController.textColor,
                    onColorChanged: (color) =>
                        _windowController.textColor = color,
                    enableLabel: true, // only on portrait mode
                    portraitOnly: true,
                  )),
            ),

            //* Opacity slider:
            Obx(() => Slider(
                  label: _windowController.backgroundOpcity.toString(),
                  divisions: 20,
                  value: _windowController.backgroundOpcity,
                  min: 0,
                  max: 1,
                  onChanged: (value) =>
                      _windowController.backgroundOpcity = value,
                )),

            //* Window visibility switch:
            Obx(() => SwitchListTile(
                  title: Text(_windowController.shouldShowWindow
                      ? 'Visible'
                      : 'Hidden'),
                  value: _windowController.shouldShowWindow,
                  onChanged: (value) =>
                      _windowController.shouldShowWindow = value,
                )),

            //* Bottom buttons:
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
