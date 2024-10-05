import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../../utils/logger.dart';
import '../../widgets/fail_import_dialog.dart';
import '../../widgets/loading_widget.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../overlay_window_settings/overlay_window_settings.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        context.read<HomeBloc>().add(MediaStateChanged(state.mediaState));
      },
      child: const Scaffold(
        body: DefaultTabController(
          length: 3,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MediaSettingTitle(),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    Tab(
                      text: 'Window Settings',
                      icon: Icon(Icons.window_outlined),
                    ),
                    Tab(
                      text: 'Import Lyrics',
                      icon: Icon(Icons.folder_copy_outlined),
                    ),
                    Tab(
                      text: 'Online Lyrics',
                      icon: Icon(Icons.cloud_outlined),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    OverlayWindowSetting(),
                    LrcFormatContent(),
                    OnlineLyricContent(),
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

    final mediaAppName = context.select<HomeBloc, String>(
      (bloc) => bloc.state.mediaState?.mediaPlayerName ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.radio_outlined),
          title: isPlaying
              ? Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '$mediaAppName: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '$title - $artist'),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const Text('Play a song'),
          subtitle: isPlaying
              ? LinearProgressIndicator(
                  value: progress.isInfinite || progress.isNaN ? 0 : progress,
                )
              : null,
        ),
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

    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }
}

class OnlineLyricContent extends StatelessWidget {
  const OnlineLyricContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
      listenWhen: (previous, current) {
        final isPlaying = current.mediaState?.isPlaying ?? false;
        final homeMediaState = context.read<HomeBloc>().state.mediaState;
        if (isPlaying && homeMediaState == null) return true;

        final mediaState = current.mediaState;
        final isNewSong = previous.mediaState?.title != mediaState?.title ||
            previous.mediaState?.artist != mediaState?.artist ||
            previous.mediaState?.album != mediaState?.album;
        return isNewSong;
      },
      listener: (context, state) => context.read<HomeBloc>().add(NewSongPlayed(state.mediaState)),
      child: SingleChildScrollView(
        child: Column(
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
            BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
              listenWhen: (previous, current) => previous.mediaState?.title != current.mediaState?.title,
              listener: (context, state) => context.read<HomeBloc>().add(MediaStateChanged(state.mediaState)),
              child: Builder(
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
            ),
            BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
              listenWhen: (previous, current) => previous.mediaState?.artist != current.mediaState?.artist,
              listener: (context, state) => context.read<HomeBloc>().add(MediaStateChanged(state.mediaState)),
              child: Builder(
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
            ),
            BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
              listenWhen: (previous, current) => previous.mediaState?.album != current.mediaState?.album,
              listener: (context, state) => context.read<HomeBloc>().add(MediaStateChanged(state.mediaState)),
              child: Builder(
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
            ),
            BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
              listenWhen: (previous, current) => previous.mediaState?.duration != current.mediaState?.duration,
              listener: (context, state) => context.read<HomeBloc>().add(MediaStateChanged(state.mediaState)),
              child: ListTile(
                title: const Text('Duration'),
                subtitle: Builder(
                  builder: (context) {
                    final millis = context.select<HomeBloc, int>(
                      (bloc) => bloc.state.mediaState?.duration.toInt() ?? 0,
                    );

                    final duration = Duration(milliseconds: millis);

                    return Text(duration.mmss());
                  },
                ),
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
        ),
      ),
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
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        logger.d('AlbumAltField: ${state.albumAlt}');
        if (state.albumAlt == null) {
          _controller.clear();
        } else if (state.albumAlt != _controller.text) {
          _controller.text = state.albumAlt!;
        }
      },
      child: TextFormField(
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
      ),
    );
  }
}
