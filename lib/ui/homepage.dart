import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../singletons/window_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowController = Get.find<WindowController>();
    final songBox = SongBox();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //* Color picker:
            Expanded(
              child: Obx(() => MaterialPicker(
                    pickerColor: windowController.textColor,
                    onColorChanged: (color) =>
                        windowController.textColor = color,
                    enableLabel: true, // only on portrait mode
                    portraitOnly: true,
                  )),
            ),

            Obx(() {
              final prefix = songBox.hasSong(
                      windowController.song.artist, windowController.song.title)
                  ? 'Using: '
                  : 'Could not find: ';
              return Text('$prefix${windowController.displayingTitle}.lrc');
            }),

            //* Opacity slider:
            Obx(() => Slider(
                  label: windowController.backgroundOpcity.toString(),
                  divisions: 20,
                  value: windowController.backgroundOpcity,
                  min: 0,
                  max: 1,
                  onChanged: (value) =>
                      windowController.backgroundOpcity = value,
                )),

            //* Window visibility switch:
            Obx(() => SwitchListTile(
                  title: Text(
                      windowController.shouldShowWindow ? 'Visible' : 'Hidden'),
                  value: windowController.shouldShowWindow,
                  onChanged: (value) =>
                      windowController.shouldShowWindow = value,
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
                        onPressed: () => songBox.importLRC(),
                        label: const Text('Import LRC'),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => songBox.clearDB(),
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
}
