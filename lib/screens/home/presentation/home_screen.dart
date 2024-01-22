import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/app_preference.dart';
import '../../../services/db_helper.dart';
import '../../../services/platform_invoker.dart';
import '../../../widgets/fail_import_dialog.dart';
import 'home_screen_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      homeNotifierProvider.select((state) => state.currentIndex),
    );

    final isPlaying = ref.watch(
      homeNotifierProvider.select((state) => state.isPlaying),
    );

    final visibleFloatingWindow = ref.watch(
      homeNotifierProvider.select((state) => state.isWindowVisible),
    );

    return Stepper(
      currentStep: currentIndex,
      onStepTapped: ref.watch(homeNotifierProvider.notifier).updateStep,
      controlsBuilder: (context, details) => const SizedBox(),
      steps: [
        Step(
          isActive: currentIndex == 0,
          state: isPlaying ? StepState.complete : StepState.indexed,
          title: const MediaSettingTitle(),
          content: const MediaSettingContent(),
        ),
        Step(
          isActive: currentIndex == 1,
          state: visibleFloatingWindow ? StepState.complete : StepState.indexed,
          title: const ListTile(title: Text('Floating Window Settings')),
          content: const WindowSettingContent(),
        ),
        Step(
          isActive: currentIndex == 2,
          title: const ListTile(title: Text('Import All Your .lrc Files')),
          content: const LrcFormatContent(),
        ),
        Step(
          isActive: currentIndex == 3,
          title: const ListTile(title: Text('Reminders')),
          content: const ReminderStep(),
        ),
      ],
    );
  }
}

class MediaSettingTitle extends ConsumerWidget {
  const MediaSettingTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(
      homeNotifierProvider.select((state) => state.isPlaying),
    );

    return isPlaying
        ? ListTile(
            title: Consumer(
              builder: (context, ref, child) {
                final title = ref.watch(
                  homeNotifierProvider.select((state) => state.title),
                );
                final artist = ref.watch(
                  homeNotifierProvider.select((state) => state.artist),
                );
                return Text(
                  'Currently Playing: $title - $artist',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            subtitle: Consumer(
              builder: (context, ref, child) {
                final progress = ref.watch(
                  homeNotifierProvider.select((state) => state.progress),
                );
                return LinearProgressIndicator(value: progress);
              },
            ),
          )
        : const ListTile(
            title: Text('Play a song'),
            subtitle: Text('with your favorite music player'),
          );
  }
}

class MediaSettingContent extends ConsumerWidget {
  const MediaSettingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final isPlaying = ref.watch(
      homeNotifierProvider.select((state) => state.isPlaying),
    );

    return isPlaying
        ? ListTile(
            leading: const Icon(Icons.radio_outlined),
            title: Consumer(
              builder: (context, ref, child) {
                final mediaAppName = ref.watch(
                  homeNotifierProvider.select(
                    (state) => state.mediaAppName,
                  ),
                );
                return Text('Music Provider: $mediaAppName');
              },
            ),
            subtitle: const Text(
              'If the detected music provider is incorrect, '
              'please restart your music player and try again.',
            ),
          )
        : Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton.large(
                  heroTag: 'play',
                  onPressed: () => Future.delayed(
                      const Duration(milliseconds: 100),
                      () => ref
                          .read(platformInvokerProvider)
                          .start3rdMusicPlayer()),
                  child: const Text('Start A Music App'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Text(
                  'If you already have a music app playing, please '
                  'restart it and try again.',
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              )
            ],
          );
  }
}

class WindowSettingContent extends ConsumerWidget {
  const WindowSettingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleFloatingWindow = ref.watch(
      homeNotifierProvider.select((state) => state.isWindowVisible),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          title: const Text('Enable'),
          value: visibleFloatingWindow,
          onChanged: ref.read(homeNotifierProvider.notifier).toggleWindow,
        ),
        ListTile(
          title: const Text('Color Scheme'),
          leading: const Icon(Icons.color_lens),
          enabled: visibleFloatingWindow,
          trailing: ColoredBox(
            color: Color(ref.watch(preferenceProvider).color),
            child: const SizedBox(width: 24, height: 24),
          ),
          onTap: () => showDialog(
            builder: (context) => AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: Consumer(
                  builder: (context, ref, child) {
                    final color = ref.watch(
                      preferenceProvider.select((value) => value.color),
                    );
                    return ColorPicker(
                      pickerColor: Color(color),
                      onColorChanged: ref
                          .read(homeNotifierProvider.notifier)
                          .updateWindowColor,
                      paletteType: PaletteType.hueWheel,
                      hexInputBar: true,
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: context.pop,
                  child: const Text('Got it'),
                ),
              ],
            ),
            context: context,
          ),
        ),
        ListTile(
          enabled: visibleFloatingWindow,
          leading: const Icon(Icons.opacity),
          trailing: Consumer(
            builder: (context, ref, child) {
              final opacity = ref.watch(
                preferenceProvider.select((value) => value.opacity),
              );
              return Text('$opacity%');
            },
          ),
          title: const Text('Window Opacity'),
        ),
        Consumer(
          builder: (context, ref, child) {
            final opacity = ref.watch(
              preferenceProvider.select((value) => value.opacity),
            );
            return Slider(
              max: 100,
              divisions: 20,
              value: opacity,
              label: '$opacity%',
              onChanged: visibleFloatingWindow
                  ? ref.watch(homeNotifierProvider.notifier).updateWindowOpacity
                  : null,
            );
          },
        ),
      ],
    );
  }
}

class LrcFormatContent extends StatelessWidget {
  const LrcFormatContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListTile(
          title: const Text('File for current song should contain:'),
          subtitle: Consumer(
            builder: (context, ref, child) {
              final title = ref.watch(
                homeNotifierProvider.select((state) => state.title),
              );
              final artist = ref.watch(
                homeNotifierProvider.select((state) => state.artist),
              );
              return Text(
                '[ti:$title]\n'
                '[ar:$artist]',
                style: TextStyle(color: colorScheme.outline),
              );
            },
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final isProcessing = ref.watch(
              homeNotifierProvider.select((state) => state.isProcessingFiles),
            );
            return isProcessing
                ? ElevatedButton.icon(
                    onPressed: null,
                    icon: const Center(child: CircularProgressIndicator()),
                    label: const Text('Importing...'),
                  )
                : ElevatedButton.icon(
                    onPressed: () => ref
                        .read(homeNotifierProvider.notifier)
                        .importLRCs()
                        .then((failedFiles) {
                      ref.invalidate(allRawLyricsProvider);
                      if (failedFiles.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => FailedImportDialog(failedFiles),
                        );
                      }
                    }),
                    icon: const Icon(Icons.drive_folder_upload_outlined),
                    label: const Text('Import'),
                  );
          },
        ),
      ],
    );
  }
}

class ReminderStep extends StatelessWidget {
  const ReminderStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
          title: Text(
            '1. You can drag the floating window to anywhere on the screen.',
          ),
        ),
        ListTile(
          title: Text(
            '2. You can tap the floating window to show/hide the title, progress and button.',
          ),
        ),
        ListTile(
          title: Text(
            '3. Find the "Lyric List" tab in the drawer to delete the imported lyrics.',
          ),
        ),
        ListTile(
          title: Text(
            '4. Killing this app will not close the floating window but will stop the lyric update.',
          ),
        ),
        ListTile(
          title: Text(
            '5. If LRC file correctly imported but not showing, please try to restart the app.',
          ),
        ),
      ],
    );
  }
}
