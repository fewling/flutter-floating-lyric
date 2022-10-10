import 'package:floating_lyric/singletons/expansion_panel_controller.dart';
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
    final expansionPanelController = Get.find<ExpansionPanelController>();
    final songBox = SongBox();

    final pad = MediaQuery.of(context).size.height * 0.02;

    final headerTxtStyle = Theme.of(context)
        .textTheme
        .headline6
        ?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings_overscan_outlined),
        title: const Text('Floating Window Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: pad),

              //* Window visibility switch:
              Obx(() => SwitchListTile(
                    title: Text(
                      '${windowController.shouldShowWindow ? 'Show' : 'Hide'} Window ',
                      style: headerTxtStyle,
                    ),
                    value: windowController.shouldShowWindow,
                    onChanged: (value) =>
                        windowController.shouldShowWindow = value,
                  )),

              Obx(
                () => ExpansionPanelList(
                  animationDuration: const Duration(seconds: 1),
                  expansionCallback: (panelIndex, isExpanded) {
                    switch (panelIndex) {
                      case 0:
                        expansionPanelController.isWindowPanelExpanded =
                            !isExpanded;
                        break;
                      case 1:
                        expansionPanelController.isFilePanelExpanded =
                            !isExpanded;
                        break;
                      case 2:
                        expansionPanelController.isColorPanelExpanded =
                            !isExpanded;
                        break;
                    }
                  },
                  children: [
                    ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded:
                            expansionPanelController.isWindowPanelExpanded,
                        headerBuilder: (_, __) => ListTile(
                                title: Text(
                              'Window Customization',
                              style: headerTxtStyle,
                            )),
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                  'Background transparency (${(windowController.backgroundOpcity * 100).toInt()}%)'),
                            ),

                            //* Opacity slider:
                            Slider(
                              label:
                                  windowController.backgroundOpcity.toString(),
                              divisions: 20,
                              value: windowController.backgroundOpcity,
                              min: 0,
                              max: 1,
                              onChanged: (value) =>
                                  windowController.backgroundOpcity = value,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Text(
                                  'Window Width (${(windowController.widthProportion).toInt()}%)'),
                            ),

                            //* Width slider:
                            Slider(
                              label:
                                  windowController.widthProportion.toString(),
                              value: windowController.widthProportion,
                              min: 30.0,
                              max: 100.0,
                              onChanged: (value) =>
                                  windowController.widthProportion = value,
                            ),
                          ],
                        )),
                    ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: expansionPanelController.isFilePanelExpanded,
                      headerBuilder: (_, __) => ListTile(
                          title: Text('LRC Files Management',
                              style: headerTxtStyle)),
                      body: Column(
                        children: [
                          ListTile(
                            title: Text(
                              songBox.hasSong(windowController.song.artist,
                                      windowController.song.title)
                                  ? 'Currently using file: '
                                  : 'Expected file: ',
                              style: TextStyle(
                                  color: songBox.hasSong(
                                          windowController.song.artist,
                                          windowController.song.title)
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).errorColor),
                            ),
                            subtitle:
                                Text('${windowController.displayingTitle}.lrc'),
                            leading: Icon(
                                songBox.hasSong(windowController.song.artist,
                                        windowController.song.title)
                                    ? Icons.music_note_outlined
                                    : Icons.music_off,
                                color: songBox.hasSong(
                                        windowController.song.artist,
                                        windowController.song.title)
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).errorColor),
                          ),
                          ListTile(
                            title: const Text('Import LRC'),
                            onTap: () => songBox.importLRC(),
                            leading: const Icon(Icons.add),
                            trailing: const Icon(Icons.chevron_right_outlined),
                          ),
                          ListTile(
                            title: const Text('Clear Storage'),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'This will empty all stored lyrics in this app (does not remove the original files).'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      songBox.clearDB();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('I understand'),
                                  )
                                ],
                              ),
                            ),
                            leading: const Icon(Icons.delete),
                            trailing: const Icon(Icons.chevron_right_outlined),
                          ),
                        ],
                      ),
                    ),
                    ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: expansionPanelController.isColorPanelExpanded,
                      headerBuilder: (_, __) => ListTile(
                        title: Text('Color the Lyrics', style: headerTxtStyle),
                      ),
                      body: Column(children: [
                        MaterialPicker(
                          pickerColor: windowController.textColor,
                          onColorChanged: (color) =>
                              windowController.textColor = color,
                          enableLabel: true, // only on portrait mode
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
