import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:system_alert_window/system_alert_window.dart';
import '../singletons/window_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WindowController _windowController = WindowController();
  final _songBox = SongBox();

  @override
  void initState() {
    Get.put(_windowController);

    SystemAlertWindow.requestPermissions(
        prefMode: SystemWindowPrefMode.OVERLAY);

    super.initState();
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
                        onPressed: () => _songBox.importLRC(),
                        label: const Text('Import LRC'),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _songBox.clearDB(),
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
