import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../services/db_helper.dart';
import '../../../services/floating_lyrics/floating_lyric_notifier.dart';
import '../../../services/preferences/app_preference_notifier.dart';
import '../../../widgets/fail_import_dialog.dart';
import '../../../widgets/loading_widget.dart';
import 'home_screen_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      homeNotifierProvider.select((state) => state.currentIndex),
    );

    final isPlaying = ref.watch(
      homeNotifierProvider.select((s) => s.mediaState?.isPlaying ?? false),
    );

    final visibleFloatingWindow = ref.watch(
      homeNotifierProvider.select((s) => s.isWindowVisible),
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
          title: const Text('Floating Window Settings'),
          content: const WindowSettingContent(),
        ),
        Step(
          isActive: currentIndex == 2,
          title: const Text('Import Local .lrc Files'),
          content: const LrcFormatContent(),
        ),
        Step(
          isActive: currentIndex == 3,
          title: const Text('Fetch Lyrics Online'),
          content: const OnlineLyricContent(),
          subtitle: const Text('Powered by lrclib (Experimental)'),
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
        homeNotifierProvider.select((s) => s.mediaState?.isPlaying ?? false));

    final title = ref
        .watch(homeNotifierProvider.select((s) => s.mediaState?.title ?? ''));
    final artist = ref
        .watch(homeNotifierProvider.select((s) => s.mediaState?.artist ?? ''));

    final position = ref
        .watch(homeNotifierProvider.select((s) => s.mediaState?.position ?? 0));
    final duration = ref.watch(homeNotifierProvider
        .select((value) => value.mediaState?.duration ?? 0));
    final progress = position / duration;

    final label = isPlaying
        ? Text(
            'Currently Playing: $title - $artist',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : const Text('Play a song');

    final progressBar = isPlaying
        ? LinearProgressIndicator(
            value: progress.isInfinite || progress.isNaN ? 0 : progress,
          )
        : const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        const SizedBox(height: 8),
        progressBar,
      ],
    );
  }
}

class MediaSettingContent extends ConsumerWidget {
  const MediaSettingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final isPlaying = ref.watch(
      homeNotifierProvider.select((s) => s.mediaState?.isPlaying ?? false),
    );

    return isPlaying
        ? ListTile(
            leading: const Icon(Icons.radio_outlined),
            title: Consumer(
              builder: (context, ref, child) {
                final mediaAppName = ref.watch(
                  homeNotifierProvider.select(
                    (s) => s.mediaState?.mediaPlayerName ?? '',
                  ),
                );
                return Text('Music Provider: $mediaAppName');
              },
            ),
          )
        : Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton.large(
                  heroTag: 'play',
                  onPressed: ref
                      .read(homeNotifierProvider.notifier)
                      .start3rdMusicPlayer,
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
        Consumer(
          builder: (context, ref, child) {
            final showMillis = ref.watch(
              preferenceNotifierProvider.select(
                (value) => value.showMilliseconds,
              ),
            );
            return ListTile(
              enabled: visibleFloatingWindow,
              leading: const Icon(Icons.timelapse_outlined),
              title: showMillis
                  ? const Text('Show Milliseconds')
                  : const Text('Hide Milliseconds'),
              trailing: Switch(
                value: showMillis,
                onChanged: !visibleFloatingWindow
                    ? null
                    : ref
                        .read(homeNotifierProvider.notifier)
                        .toggleMillisVisibility,
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final showBar = ref.watch(
              preferenceNotifierProvider.select(
                (value) => value.showProgressBar,
              ),
            );
            return ListTile(
              enabled: visibleFloatingWindow,
              leading: const Icon(Icons.linear_scale_outlined),
              title: showBar
                  ? const Text('Show Progress Bar')
                  : const Text('Hide Progress Bar'),
              trailing: Switch(
                value: showBar,
                onChanged: !visibleFloatingWindow
                    ? null
                    : ref
                        .read(homeNotifierProvider.notifier)
                        .toggleProgressBarVisibility,
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Color Scheme'),
          leading: const Icon(Icons.color_lens_outlined),
          enabled: visibleFloatingWindow,
          trailing: ColoredBox(
            color: Color(ref.watch(preferenceNotifierProvider).color),
            child: const SizedBox(width: 24, height: 24),
          ),
          onTap: () => showDialog(
            builder: (context) => AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: Consumer(
                  builder: (context, ref, child) {
                    final color = ref.watch(
                      preferenceNotifierProvider.select((value) => value.color),
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
          leading: const Icon(Icons.opacity_outlined),
          trailing: Consumer(
            builder: (context, ref, child) {
              final opacity = ref.watch(
                preferenceNotifierProvider.select((value) => value.opacity),
              );
              return Text('${opacity.toInt()}%');
            },
          ),
          title: const Text('Window Opacity'),
        ),
        Consumer(
          builder: (context, ref, child) {
            final opacity = ref.watch(
              preferenceNotifierProvider.select((value) => value.opacity),
            );
            return Slider(
              max: 100,
              divisions: 20,
              value: opacity,
              label: '${opacity.toInt()}%',
              onChanged: visibleFloatingWindow
                  ? ref.read(homeNotifierProvider.notifier).updateWindowOpacity
                  : null,
            );
          },
        ),
        ListTile(
          enabled: visibleFloatingWindow,
          leading: const Icon(Icons.format_size_outlined),
          trailing: Consumer(
            builder: (context, ref, child) {
              final fontSize = ref.watch(
                preferenceNotifierProvider.select((value) => value.fontSize),
              );

              return Text('$fontSize');
            },
          ),
          title: const Text('Lyrics Font Size'),
        ),
        Consumer(
          builder: (context, ref, child) {
            final fontSize = ref.watch(
              preferenceNotifierProvider.select((value) => value.fontSize),
            );

            return Slider(
              min: 4,
              max: 72,
              value: fontSize.toDouble(),
              label: '$fontSize%',
              onChanged: visibleFloatingWindow
                  ? (value) => ref
                      .read(homeNotifierProvider.notifier)
                      .updateFontSize(value.toInt())
                  : null,
            );
          },
        ),
      ],
    );
  }
}

class LrcFormatContent extends ConsumerWidget {
  const LrcFormatContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final title = ref.watch(
      homeNotifierProvider.select((s) => s.mediaState?.title),
    );

    final artist = ref.watch(
      homeNotifierProvider.select((s) => s.mediaState?.artist),
    );

    final isProcessing = ref.watch(
      homeNotifierProvider.select((state) => state.isProcessingFiles),
    );

    final txtTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListTile(
          titleTextStyle: txtTheme.titleSmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
          title: const Text(
            'Your LRC file should match one of the following formats:',
          ),
        ),
        ListTile(
          title: const Text('1. File name should be:'),
          subtitle: SelectableText(
            '$title - $artist.lrc',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        ListTile(
          title: const Text('2. File name should be:'),
          subtitle: SelectableText(
            '$artist - $title.lrc',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        ListTile(
          title: const Text('3. File should contain:'),
          subtitle: SelectableText(
            '[ti:$title]\n'
            '[ar:$artist]',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        if (isProcessing)
          ElevatedButton.icon(
            onPressed: null,
            icon: const Center(child: CircularProgressIndicator()),
            label: const Text('Importing...'),
          )
        else
          ElevatedButton.icon(
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
          ),
      ],
    );
  }
}

class OnlineLyricContent extends StatelessWidget {
  const OnlineLyricContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Consumer(
          builder: (context, ref, child) {
            final autoFetch = ref.watch(
              preferenceNotifierProvider.select((s) => s.autoFetchOnline),
            );
            return SwitchListTile(
              title: const Text('Auto Fetch'),
              value: autoFetch,
              onChanged: ref
                  .read(preferenceNotifierProvider.notifier)
                  .toggleAutoFetchOnline,
            );
          },
        ),
        ListTile(
          title: const Text('Title'),
          subtitle: Consumer(
            builder: (context, ref, child) {
              final title = ref.watch(
                homeNotifierProvider.select((s) => s.mediaState?.title ?? ''),
              );
              return Text(title);
            },
          ),
        ),
        ListTile(
          title: const Text('Artist'),
          subtitle: Consumer(
            builder: (context, ref, child) {
              final artist = ref.watch(
                homeNotifierProvider.select((s) => s.mediaState?.artist ?? ''),
              );
              return Text(artist);
            },
          ),
        ),
        ListTile(
          title: const Text('Album'),
          subtitle: Consumer(
            builder: (context, ref, child) {
              final album = ref.watch(
                homeNotifierProvider.select((s) => s.mediaState?.album ?? ''),
              );
              return Text(album);
            },
          ),
        ),
        ListTile(
          title: const Text('Duration'),
          subtitle: Consumer(
            builder: (context, ref, child) {
              final duration = ref.watch(
                homeNotifierProvider.select((s) => s.mediaState?.duration ?? 0),
              );

              return Text('${duration / 1000} seconds');
            },
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final isSearching = ref.watch(
              homeNotifierProvider.select((s) => s.isSearchingOnline),
            );
            final isAutoSearching = ref.watch(
              lyricStateProvider.select((s) => s.isSearchingOnline),
            );
            return ElevatedButton.icon(
              onPressed: isSearching || isAutoSearching
                  ? null
                  : () => ref
                          .read(homeNotifierProvider.notifier)
                          .fetchLyric()
                          .then((lrcResponse) {
                        final content = lrcResponse?.syncedLyrics ??
                            lrcResponse?.plainLyrics ??
                            'No lyric found for this song.';

                        return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            icon: const Icon(Icons.info_outline),
                            title: const Text('Lyric Fetch Result'),
                            content: SelectableText(content),
                            actions: [
                              TextButton(
                                onPressed: context.pop,
                                child: const Text('Close'),
                              ),
                              if (lrcResponse != null)
                                TextButton(
                                  onPressed: () => ref
                                      .read(homeNotifierProvider.notifier)
                                      .saveLyric(lrcResponse)
                                      .then((id) =>
                                          _showLyricFetchResult(context, id)),
                                  child: const Text('Save'),
                                ),
                            ],
                          ),
                        );
                      }),
              label: const Text('Search'),
              icon: isSearching
                  ? const LoadingWidget()
                  : const Icon(Icons.search),
            );
          },
        ),
      ],
    );
  }

  void _showLyricFetchResult(BuildContext context, int id) {
    context.pop();
    final colorScheme = Theme.of(context).colorScheme;

    if (id >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lyric saved successfully',
            style: TextStyle(color: colorScheme.onSecondary),
          ),
          backgroundColor: colorScheme.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving lyric',
            style: TextStyle(color: colorScheme.onError),
          ),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }
}
