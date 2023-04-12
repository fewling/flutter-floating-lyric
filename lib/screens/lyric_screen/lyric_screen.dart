import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app_preference.dart';
import '../../services/db_helper.dart';
import '../../services/platform_invoker.dart';
import '../../widgets/fail_import_dialog.dart';
import 'lyric_screen_state_provider.dart';

class LyricScreen extends ConsumerWidget {
  const LyricScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lyricStateProvider);
    final notifier = ref.watch(lyricStateProvider.notifier);
    final progress = state.position / state.duration;

    final colorScheme = Theme.of(context).colorScheme;
    final pref = ref.watch(preferenceProvider);

    return Stepper(
      currentStep: state.currentStep,
      onStepTapped: notifier.updateStep,
      controlsBuilder: (context, details) => const SizedBox(),
      steps: [
        Step(
          isActive: state.currentStep == 0,
          state: state.isPlaying ? StepState.complete : StepState.indexed,
          title: ListTile(
            title: state.isPlaying
                ? Text(
                    'Currently Playing: ${state.title} - ${state.artist}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : const Text('Play a song'),
            subtitle: state.isPlaying
                ? LinearProgressIndicator(
                    value: progress.isInfinite || progress.isNaN ? 0 : progress)
                : const Text('with your favorite music player'),
          ),
          content: state.isPlaying
              ? ListTile(
                  leading: const Icon(Icons.radio_outlined),
                  title: Text('Music Provider: ${state.mediaPlayerName}'),
                  subtitle: const Text(
                      'If the detected music provider is incorrect, please restart your music player and try again.'),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton.large(
                        onPressed: () => Future.delayed(
                            const Duration(milliseconds: 100),
                            () => ref
                                .read(platformInvokerProvider)
                                .start3rdMusicPlayer()),
                        child: const Text('Start A Music App'),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 16),
                      child: Text(
                        'If you already have a music app playing, please '
                        'restart it and try again.',
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                      ),
                    )
                  ],
                ),
        ),
        Step(
          isActive: state.currentStep == 1,
          state: state.isFloatingWindowShown
              ? StepState.complete
              : StepState.indexed,
          title: const ListTile(title: Text('Floating Window Settings')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                enabled: state.isFloatingWindowShown,
                leading: Icon(state.isFloatingWindowShown
                    ? Icons.visibility
                    : Icons.visibility_off),
                title: const Text('Enable'),
                trailing: Switch(
                  value: state.isFloatingWindowShown,
                  onChanged: notifier.toggleWindowVisibility,
                ),
              ),
              ListTile(
                enabled: state.isFloatingWindowShown,
                leading: const Icon(Icons.window),
                title: const Text('Window Transparency'),
              ),
              Slider(
                max: 100,
                divisions: 20,
                value: pref.opacity,
                label: '${pref.opacity}%',
                onChanged: !state.isFloatingWindowShown
                    ? null
                    : notifier.updateWindowOpacity,
              ),
            ],
          ),
        ),
        Step(
          isActive: state.currentStep == 2,
          title: const ListTile(
            title: Text('Import .lrc Files'),
            subtitle: Text('you only need to do this once'),
          ),
          content: Column(
            children: [
              const ListTile(
                  title: Text(
                      'Pick a .LRC file matching ONE of the following conditions:')),
              RadioListTile(
                value: 0,
                groupValue: ref
                    .watch(
                        lyricExistsProvider('${state.title} - ${state.artist}'))
                    .when(
                      data: (data) => data ? 0 : -1,
                      error: (_, __) => -1,
                      loading: () => -1,
                    ),
                onChanged: null,
                title: const Text('File name:'),
                subtitle: Text('${state.title} - ${state.artist}.lrc'),
              ),
              RadioListTile(
                value: 1,
                groupValue: ref
                    .watch(
                        lyricExistsProvider('${state.artist} - ${state.title}'))
                    .when(
                      data: (data) => data ? 1 : -1,
                      error: (_, __) => -1,
                      loading: () => -1,
                    ),
                title: const Text('File name:'),
                subtitle: Text('${state.artist} - ${state.title}.lrc'),
                onChanged: null,
              ),
              RadioListTile(
                value: 2,
                groupValue: -1,
                title: Text('Your .lrc file contains:\n'
                    '[ti:${state.title}]\n'
                    '[ar:${state.artist}]'),
                onChanged: null,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: FloatingActionButton.large(
                  onPressed: () => state.isProcessingFiles
                      ? null
                      : notifier.pickLyrics().then((failedFiles) {
                          ref.invalidate(allRawLyricsProvider);
                          if (failedFiles.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => FailedImportDialog(failedFiles),
                            );
                          }
                        }),
                  child: state.isProcessingFiles
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Import'),
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: state.currentStep == 3,
          title: const ListTile(title: Text('Reminders')),
          content: Column(
            children: const [
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
                  '3. Find the "Lyric List" tab in the drawer to edit/delete the imported lyrics.',
                ),
              ),
              ListTile(
                title: Text(
                  '4. Killing this app will not close the floating window but will stop the lyric update.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
