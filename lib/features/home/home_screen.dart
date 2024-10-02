import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../widgets/fail_import_dialog.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/overlay_window.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../overlay_window_settings/bloc/overlay_window_settings_bloc.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/home_bloc.dart';

final homeScreenOverlayWindowMeasureKey = GlobalKey();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<HomeBloc, int>(
      (bloc) => bloc.state.currentIndex,
    );

    final isPlaying = context.select<HomeBloc, bool>(
      (bloc) => bloc.state.mediaState?.isPlaying ?? false,
    );

    final visibleFloatingWindow = context.select<OverlayWindowSettingsBloc, bool>(
      (bloc) => bloc.state.isWindowVisible,
    );

    return BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        context.read<HomeBloc>().add(MediaStateChanged(state.mediaState));
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<OverlayWindowSettingsBloc>().add(const OverlayWindowVisibilityToggled()),
          child: const Icon(Icons.bug_report_outlined),
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 0,
              child: Builder(
                builder: (context) => OverlayWindow(
                  key: homeScreenOverlayWindowMeasureKey,
                  settings: context.select((OverlayWindowSettingsBloc bloc) => bloc.state.settings),
                  // debugText: 'AppColor: ${context.watch<OverlayWindowSettingsBloc>().state.settings.appColorScheme}',
                ),
              ),
            ),
            Stepper(
              currentStep: currentIndex,
              onStepTapped: (value) => context.read<HomeBloc>().add(StepTapped(value)),
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
            ),
          ],
        ),
      ),
    );
  }
}

class MediaSettingTitle extends StatelessWidget {
  const MediaSettingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<HomeBloc, bool>(
      (bloc) => bloc.state.mediaState?.isPlaying ?? false,
    );

    final title = context.select<HomeBloc, String>(
      (bloc) => bloc.state.mediaState?.title ?? '',
    );

    final artist = context.select<HomeBloc, String>(
      (bloc) => bloc.state.mediaState?.artist ?? '',
    );

    final position = context.select<HomeBloc, int>(
      (bloc) => bloc.state.mediaState?.position.toInt() ?? 0,
    );

    final duration = context.select<HomeBloc, int>(
      (bloc) => bloc.state.mediaState?.duration.toInt() ?? 0,
    );

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

class MediaSettingContent extends StatelessWidget {
  const MediaSettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isPlaying = context.select<HomeBloc, bool>(
      (bloc) => bloc.state.mediaState?.isPlaying ?? false,
    );

    return isPlaying
        ? ListTile(
            leading: const Icon(Icons.radio_outlined),
            title: Builder(
              builder: (context) {
                final mediaAppName = context.select<HomeBloc, String>(
                  (bloc) => bloc.state.mediaState?.mediaPlayerName ?? '',
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
                  onPressed: () => context.read<HomeBloc>().add(const StartMusicPlayerRequested()),
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

class WindowSettingContent extends StatelessWidget {
  const WindowSettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleFloatingWindow = context.select<OverlayWindowSettingsBloc, bool>(
      (bloc) => bloc.state.isWindowVisible,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          title: const Text('Enable'),
          value: visibleFloatingWindow,
          onChanged: (_) => context.read<OverlayWindowSettingsBloc>().add(const OverlayWindowVisibilityToggled()),
        ),
        Builder(
          builder: (context) {
            final showMillis = context.select<PreferenceBloc, bool>(
              (bloc) => bloc.state.showMilliseconds,
            );

            return ListTile(
              enabled: visibleFloatingWindow,
              leading: const Icon(Icons.timelapse_outlined),
              title: showMillis ? const Text('Show Milliseconds') : const Text('Hide Milliseconds'),
              trailing: Switch(
                value: showMillis,
                onChanged: !visibleFloatingWindow
                    ? null
                    : (value) => context.read<PreferenceBloc>().add(const ShowMillisecondsToggled()),
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            final showBar = context.select<PreferenceBloc, bool>(
              (bloc) => bloc.state.showProgressBar,
            );

            return ListTile(
              enabled: visibleFloatingWindow,
              leading: const Icon(Icons.linear_scale_outlined),
              title: showBar ? const Text('Show Progress Bar') : const Text('Hide Progress Bar'),
              trailing: Switch(
                value: showBar,
                onChanged: !visibleFloatingWindow
                    ? null
                    : (value) => context.read<PreferenceBloc>().add(const ShowProgressBarToggled()),
              ),
            );
          },
        ),
        Builder(
          builder: (context) {
            final showLine2 = context.select<PreferenceBloc, bool>(
              (bloc) => bloc.state.showLine2,
            );

            return ListTile(
              enabled: visibleFloatingWindow,
              leading: const Icon(Icons.linear_scale_outlined),
              title: showLine2 ? const Text('Show Line 2') : const Text('Hide Line 2'),
              trailing: Switch(
                value: showLine2,
                onChanged: !visibleFloatingWindow
                    ? null
                    : (value) => context.read<PreferenceBloc>().add(const ShowLine2Toggled()),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Color Scheme'),
          leading: const Icon(Icons.color_lens_outlined),
          enabled: visibleFloatingWindow,
          trailing: Builder(builder: (context) {
            final color = context.select<PreferenceBloc, int>(
              (bloc) => bloc.state.color,
            );

            return ColoredBox(
              color: Color(color),
              child: const SizedBox(width: 24, height: 24),
            );
          }),
          onTap: () => showDialog(
            builder: (dialogCtx) => BlocProvider.value(
              value: context.read<PreferenceBloc>(),
              child: AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: Builder(
                    builder: (context) {
                      final color = context.select<PreferenceBloc, int>(
                        (bloc) => bloc.state.color,
                      );

                      return ColorPicker(
                        pickerColor: Color(color),
                        onColorChanged: (value) => context.read<PreferenceBloc>().add(ColorUpdated(value)),
                        paletteType: PaletteType.hueWheel,
                        hexInputBar: true,
                      );
                    },
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(dialogCtx).pop(),
                    child: const Text('Got it'),
                  ),
                ],
              ),
            ),
            context: context,
          ),
        ),
        ListTile(
          enabled: visibleFloatingWindow,
          leading: const Icon(Icons.opacity_outlined),
          trailing: Builder(
            builder: (context) {
              final opacity = context.select<PreferenceBloc, double>(
                (bloc) => bloc.state.opacity,
              );

              return Text('${opacity.toInt()}%');
            },
          ),
          title: const Text('Window Opacity'),
        ),
        Builder(
          builder: (context) {
            final opacity = context.select<PreferenceBloc, double>(
              (bloc) => bloc.state.opacity,
            );
            return Slider(
              max: 100,
              divisions: 20,
              value: opacity,
              label: '${opacity.toInt()}%',
              onChanged: visibleFloatingWindow ? (o) => context.read<PreferenceBloc>().add(OpacityUpdated(o)) : null,
            );
          },
        ),
        ListTile(
          enabled: visibleFloatingWindow,
          leading: const Icon(Icons.format_size_outlined),
          trailing: Builder(
            builder: (context) {
              final fontSize = context.select<PreferenceBloc, int>(
                (bloc) => bloc.state.fontSize,
              );

              return Text('$fontSize');
            },
          ),
          title: const Text('Lyrics Font Size'),
        ),
        Builder(
          builder: (context) {
            final fontSize = context.select<PreferenceBloc, int>(
              (bloc) => bloc.state.fontSize,
            );

            return Slider(
              min: 4,
              max: 72,
              value: fontSize.toDouble(),
              label: '$fontSize%',
              onChanged: visibleFloatingWindow
                  ? (value) => context.read<PreferenceBloc>().add(FontSizeUpdated(value.toInt()))
                  : null,
            );
          },
        ),
        ListTile(
          title: const Text('Window Interactions'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final isLocked = context.select<HomeBloc, bool>(
                    (bloc) => bloc.state.isWindowLocked,
                  );

                  return SegmentedButton(
                    selected: {isLocked},
                    onSelectionChanged: (v) => context.read<HomeBloc>().add(WindowLockToggled(v.first)),
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: const Text('Movable'),
                        icon: const Icon(Icons.drag_handle_outlined),
                        enabled: visibleFloatingWindow,
                      ),
                      ButtonSegment(
                        value: true,
                        label: const Text('Locked'),
                        icon: const Icon(Icons.lock_outlined),
                        enabled: visibleFloatingWindow,
                      ),
                    ],
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final isIgnoreTouch = context.select<HomeBloc, bool>(
                    (bloc) => bloc.state.isWIndowIgnoreTouch,
                  );
                  return SegmentedButton(
                    selected: {isIgnoreTouch},
                    onSelectionChanged: (v) => context.read<HomeBloc>().add(WindowLockToggled(v.first)),
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: const Text('Handle Touch'),
                        icon: const Icon(Icons.touch_app_outlined),
                        enabled: visibleFloatingWindow,
                      ),
                      ButtonSegment(
                        value: true,
                        label: const Text('Ignore Touch'),
                        icon: const Icon(Icons.do_not_touch_outlined),
                        enabled: visibleFloatingWindow,
                      ),
                    ],
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final isTouchThru = context.select<HomeBloc, bool>(
                    (bloc) => bloc.state.isWindowTouchThrough,
                  );
                  return SwitchListTile(
                    value: isTouchThru,
                    title: const Text('Touch Through ⚠️'),
                    subtitle: isTouchThru
                        ? const Text(
                            'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\n'
                            "Such issue is due to Android's design limitation and is out of this app's control. 🙏",
                          )
                        : null,
                    onChanged: visibleFloatingWindow
                        ? (_) => context.read<HomeBloc>().add(const WindowTouchThroughToggled())
                        : null,
                  );
                },
              ),
            ],
          ),
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

    final title = context.select<HomeBloc, String>(
      (bloc) => bloc.state.mediaState?.title ?? '',
    );

    final artist = context.select<HomeBloc, String>(
      (bloc) => bloc.state.mediaState?.artist ?? '',
    );

    final isProcessing = context.select<HomeBloc, bool>(
      (bloc) => bloc.state.isProcessingFiles,
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
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) => previous.failedFiles != current.failedFiles,
            listener: (context, state) {
              if (state.failedFiles.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => FailedImportDialog(state.failedFiles),
                );
              }
            },
            child: ElevatedButton.icon(
              onPressed: () => context.read<HomeBloc>().add(const ImportLRCsRequested()),
              icon: const Icon(Icons.drive_folder_upload_outlined),
              label: const Text('Import'),
            ),
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
        Builder(
          builder: (context) {
            final autoFetchOnline = context.select<PreferenceBloc, bool>(
              (bloc) => bloc.state.autoFetchOnline,
            );
            return SwitchListTile(
              title: const Text('Auto Fetch'),
              value: autoFetchOnline,
              onChanged: (value) => context.read<PreferenceBloc>().add(const AutoFetchOnlineToggled()),
            );
          },
        ),
        Builder(
          builder: (context) {
            final isEditingTitle = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.isEditingTitle,
            );
            final title = context.select<HomeBloc, String?>(
              (bloc) => bloc.state.titleAlt,
            );

            return isEditingTitle
                ? TitleAltField(title: title)
                : ListTile(
                    title: const Text('Title'),
                    subtitle: Text(title ?? ''),
                    onTap: () => context.read<HomeBloc>().add(const EditFieldRequested(isTitle: true)),
                    trailing: const Icon(Icons.edit_outlined),
                  );
          },
        ),
        Builder(
          builder: (context) {
            final isEditingArtist = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.isEditingArtist,
            );

            final artist = context.select<HomeBloc, String?>(
              (bloc) => bloc.state.artistAlt,
            );

            return isEditingArtist
                ? ArtistAltField(artist: artist)
                : ListTile(
                    title: const Text('Artist'),
                    subtitle: Text(artist ?? ''),
                    onTap: () => context.read<HomeBloc>().add(const EditFieldRequested(isArtist: true)),
                    trailing: const Icon(Icons.edit_outlined),
                  );
          },
        ),
        Builder(
          builder: (context) {
            final isEditingAlbum = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.isEditingAlbum,
            );

            final album = context.select<HomeBloc, String?>(
              (bloc) => bloc.state.albumAlt,
            );

            return isEditingAlbum
                ? AlbumAltField(album: album)
                : ListTile(
                    title: const Text('Album'),
                    subtitle: Text(album ?? ''),
                    onTap: () => context.read<HomeBloc>().add(const EditFieldRequested(isAlbum: true)),
                    trailing: const Icon(Icons.edit_outlined),
                  );
          },
        ),
        ListTile(
          title: const Text('Duration'),
          subtitle: Builder(
            builder: (context) {
              final duration = context.select<HomeBloc, int>(
                (bloc) => bloc.state.mediaState?.duration.toInt() ?? 0,
              );

              return Text('${duration / 1000} seconds');
            },
          ),
        ),
        Builder(
          builder: (context) {
            final isSearching = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.isSearchingOnline,
            );

            final isAutoSearching = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.isSearchingOnline,
            );

            final noMediaState = context.select<HomeBloc, bool>(
              (bloc) => bloc.state.mediaState == null,
            );

            return BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                final resp = state.lrcLibResponse;
                if (resp != null) {
                  final content = resp.syncedLyrics ?? resp.plainLyrics ?? 'No lyric found for this song.';
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => BlocProvider.value(
                      value: context.read<HomeBloc>(),
                      child: AlertDialog(
                        icon: const Icon(Icons.info_outline),
                        title: const Text('Lyric Fetch Result'),
                        content: SelectableText(content),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            child: const Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(SaveLyricResponseRequested(resp));
                              Navigator.of(dialogCtx).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                  context.read<HomeBloc>().add(const SearchResponseReceived());
                }
              },
              child: ElevatedButton.icon(
                onPressed: isSearching || isAutoSearching || noMediaState
                    ? null
                    : () => context.read<HomeBloc>().add(const SearchOnlineRequested()),
                label: const Text('Search'),
                icon: isSearching ? const LoadingWidget() : const Icon(Icons.search),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TitleAltField extends StatefulWidget {
  const TitleAltField({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<TitleAltField> createState() => _TitleAltFieldState();
}

class _TitleAltFieldState extends State<TitleAltField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.title ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: true,
      onFieldSubmitted: (value) => context.read<HomeBloc>().add(SaveTitleAltRequested(value)),
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'Title of the song',
        suffixIcon: IconButton(
          onPressed: () => context.read<HomeBloc>().add(SaveTitleAltRequested(_controller.text)),
          icon: const Icon(Icons.done),
        ),
      ),
    );
  }
}

class ArtistAltField extends StatefulWidget {
  const ArtistAltField({
    super.key,
    this.artist,
  });

  final String? artist;

  @override
  State<ArtistAltField> createState() => _ArtistAltFieldState();
}

class _ArtistAltFieldState extends State<ArtistAltField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.artist ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: true,
      onFieldSubmitted: (value) => context.read<HomeBloc>().add(SaveArtistAltRequested(value)),
      decoration: InputDecoration(
        labelText: 'Artist',
        hintText: 'Artist of the song',
        suffixIcon: IconButton(
          onPressed: () => context.read<HomeBloc>().add(SaveArtistAltRequested(_controller.text)),
          icon: const Icon(Icons.done),
        ),
      ),
    );
  }
}

class AlbumAltField extends StatefulWidget {
  const AlbumAltField({
    super.key,
    this.album,
  });

  final String? album;

  @override
  State<AlbumAltField> createState() => _AlbumAltFieldState();
}

class _AlbumAltFieldState extends State<AlbumAltField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.album ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: true,
      onFieldSubmitted: (value) => context.read<HomeBloc>().add(SaveAlbumAltRequested(value)),
      decoration: InputDecoration(
        labelText: 'Album',
        hintText: 'Album of the song',
        suffixIcon: IconButton(
          onPressed: () => context.read<HomeBloc>().add(SaveAlbumAltRequested(_controller.text)),
          icon: const Icon(Icons.done),
        ),
      ),
    );
  }
}
