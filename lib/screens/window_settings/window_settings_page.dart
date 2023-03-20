import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/floating_window_state.dart';
import 'window_settings_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingState = ref.watch(floatingStateProvider);
    final floatingNotifier = ref.watch(floatingStateProvider.notifier);

    final screenState = ref.watch(windowSettingScreenStateProvider);
    final screenNotifier = ref.watch(windowSettingScreenStateProvider.notifier);

    final songBox = SongBox();

    final pad = MediaQuery.of(context).size.height * 0.02;

    final headerTxtStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

    final colorScheme = Theme.of(context).colorScheme;

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
              SwitchListTile(
                title: Text(
                  '${floatingState.shouldShowWindow ? 'Show' : 'Hide'} Floating Window ',
                  style: headerTxtStyle,
                ),
                value: floatingState.shouldShowWindow,
                onChanged: floatingNotifier.toggleWindowVisibility,
              ),
              ExpansionPanelList(
                animationDuration: const Duration(milliseconds: 400),
                expansionCallback: (panelIndex, isExpanded) =>
                    screenNotifier.togglePanel(panelIndex),
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: screenState.panelIndexes.contains(0),
                    headerBuilder: (context, isExpanded) => ListTile(
                      title: Text('Window Customization', style: headerTxtStyle),
                    ),
                    body: Column(
                      children: [
                        ListTile(
                          title: Text(
                              'Background Transparency: (${(floatingState.backgroundOpacity * 100).toInt()}%)'),
                          subtitle: Slider(
                            label: floatingState.backgroundOpacity.toString(),
                            divisions: 20,
                            value: floatingState.backgroundOpacity,
                            min: 0,
                            max: 1,
                            onChanged: floatingNotifier.updateBackgroundOpacity,
                          ),
                        ),
                        ListTile(
                          title:
                              Text('Window Width: (${(floatingState.widthProportion).toInt()}%)'),
                          subtitle: Slider(
                            label: floatingState.widthProportion.toString(),
                            value: floatingState.widthProportion,
                            min: 30.0,
                            max: 100.0,
                            onChanged: floatingNotifier.updateWidthProportion,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: screenState.panelIndexes.contains(1),
                    headerBuilder: (context, isExpanded) => const ListTile(
                      title: Text('LRC Files Management'),
                    ),
                    body: ListTile(
                      title: Text(
                        songBox.hasSong(floatingState.song)
                            ? 'Currently using file: '
                            : 'Expected file: ',
                        style: TextStyle(
                            color: songBox.hasSong(floatingState.song) ? null : colorScheme.error),
                      ),
                    ),
                  ),
                  ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: screenState.panelIndexes.contains(2),
                    headerBuilder: (_, __) => ListTile(
                      title: Text('Color the Lyrics', style: headerTxtStyle),
                    ),
                    body: MaterialPicker(
                      pickerColor: floatingState.textColor,
                      onColorChanged: floatingNotifier.updateTextColor,
                      enableLabel: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
