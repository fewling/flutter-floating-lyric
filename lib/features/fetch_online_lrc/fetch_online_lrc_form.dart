import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/local/local_db_repo.dart';
import '../../service/db/local/local_db_service.dart';
import '../../service/lrc_lib/lrc_lib_service.dart';
import '../../services/lrclib/repo/lrclib_repository.dart';
import '../../utils/extensions/custom_extensions.dart';
import '../../widgets/loading_widget.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/fetch_online_lrc_form_bloc.dart';

class FetchOnlineLrcForm extends StatelessWidget {
  const FetchOnlineLrcForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchOnlineLrcFormBloc(
        lrcLibService: LrcLibService(
          lrcLibRepository: context.read<LrcLibRepository>(),
        ),
        localDbService: LocalDbService(
          localDBRepo: context.read<LocalDbRepo>(),
        ),
      )..add(FetchOnlineLrcFormStarted(
          album: context.read<LyricStateListenerBloc>().state.mediaState?.album,
          artist: context.read<LyricStateListenerBloc>().state.mediaState?.artist,
          title: context.read<LyricStateListenerBloc>().state.mediaState?.title,
          duration: context.read<LyricStateListenerBloc>().state.mediaState?.duration,
        )),
      child: BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
        listenWhen: (previous, current) {
          final isPlaying = current.mediaState?.isPlaying ?? false;
          if (isPlaying) return true;

          final mediaState = current.mediaState;
          final isNewSong = previous.mediaState?.title != mediaState?.title ||
              previous.mediaState?.artist != mediaState?.artist ||
              previous.mediaState?.album != mediaState?.album;
          return isNewSong;
        },
        listener: (context, state) => context.read<FetchOnlineLrcFormBloc>().add(NewSongPlayed(
              title: state.mediaState?.title,
              artist: state.mediaState?.artist,
              album: state.mediaState?.album,
            )),
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
              Builder(
                builder: (context) {
                  final isEditingTitle = context.select<FetchOnlineLrcFormBloc, bool>(
                    (bloc) => bloc.state.isEditingTitle,
                  );
                  final title = context.select<FetchOnlineLrcFormBloc, String?>(
                    (bloc) => bloc.state.titleAlt,
                  );

                  return isEditingTitle
                      ? TitleAltField(title: title)
                      : ListTile(
                          title: const Text('Title'),
                          subtitle: Text(title ?? ''),
                          onTap: () =>
                              context.read<FetchOnlineLrcFormBloc>().add(const EditFieldRequested(isTitle: true)),
                          trailing: const Icon(Icons.edit_outlined),
                        );
                },
              ),
              Builder(
                builder: (context) {
                  final isEditingArtist = context.select<FetchOnlineLrcFormBloc, bool>(
                    (bloc) => bloc.state.isEditingArtist,
                  );

                  final artist = context.select<FetchOnlineLrcFormBloc, String?>(
                    (bloc) => bloc.state.artistAlt,
                  );

                  return isEditingArtist
                      ? ArtistAltField(artist: artist)
                      : ListTile(
                          title: const Text('Artist'),
                          subtitle: Text(artist ?? ''),
                          onTap: () =>
                              context.read<FetchOnlineLrcFormBloc>().add(const EditFieldRequested(isArtist: true)),
                          trailing: const Icon(Icons.edit_outlined),
                        );
                },
              ),
              Builder(
                builder: (context) {
                  final isEditingAlbum = context.select<FetchOnlineLrcFormBloc, bool>(
                    (bloc) => bloc.state.isEditingAlbum,
                  );

                  final album = context.select<FetchOnlineLrcFormBloc, String?>(
                    (bloc) => bloc.state.albumAlt,
                  );

                  return isEditingAlbum
                      ? AlbumAltField(album: album)
                      : ListTile(
                          title: const Text('Album'),
                          subtitle: Text(album ?? ''),
                          onTap: () =>
                              context.read<FetchOnlineLrcFormBloc>().add(const EditFieldRequested(isAlbum: true)),
                          trailing: const Icon(Icons.edit_outlined),
                        );
                },
              ),
              ListTile(
                title: const Text('Duration'),
                subtitle: Builder(
                  builder: (context) {
                    final millis = context.select<LyricStateListenerBloc, int>(
                      (bloc) => bloc.state.mediaState?.duration.toInt() ?? 0,
                    );

                    final duration = Duration(milliseconds: millis);

                    return Text(duration.mmss());
                  },
                ),
              ),
              Builder(
                builder: (context) {
                  final isSearching = context.select<FetchOnlineLrcFormBloc, bool>(
                    (bloc) => bloc.state.isSearchingOnline,
                  );

                  final isAutoSearching = context.select<FetchOnlineLrcFormBloc, bool>(
                    (bloc) => bloc.state.isSearchingOnline,
                  );

                  final noMediaState = context.select<LyricStateListenerBloc, bool>(
                    (bloc) => bloc.state.mediaState == null,
                  );

                  return BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
                    listener: (context, state) {
                      final resp = state.lrcLibResponse;
                      if (resp != null) {
                        final content = resp.syncedLyrics ?? resp.plainLyrics ?? 'No lyric found for this song.';
                        showDialog(
                          context: context,
                          builder: (dialogCtx) => BlocProvider.value(
                            value: context.read<FetchOnlineLrcFormBloc>(),
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
                                    context.read<FetchOnlineLrcFormBloc>().add(SaveLyricResponseRequested(resp));
                                    Navigator.of(dialogCtx).pop();
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ),
                        );
                        context.read<FetchOnlineLrcFormBloc>().add(const SearchResponseReceived());
                      }
                    },
                    child: ElevatedButton.icon(
                      onPressed: isSearching || isAutoSearching || noMediaState
                          ? null
                          : () => context.read<FetchOnlineLrcFormBloc>().add(const SearchOnlineRequested()),
                      label: const Text('Search'),
                      icon: isSearching ? const LoadingWidget() : const Icon(Icons.search),
                    ),
                  );
                },
              ),
            ],
          ),
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
      onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(SaveTitleAltRequested(value)),
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'Title of the song',
        suffixIcon: IconButton(
          onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(SaveTitleAltRequested(_controller.text)),
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
      onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(SaveArtistAltRequested(value)),
      decoration: InputDecoration(
        labelText: 'Artist',
        hintText: 'Artist of the song',
        suffixIcon: IconButton(
          onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(SaveArtistAltRequested(_controller.text)),
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
    return BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
      listener: (context, state) {
        if (state.albumAlt == null) {
          _controller.clear();
        } else if (state.albumAlt != _controller.text) {
          _controller.text = state.albumAlt!;
        }
      },
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(SaveAlbumAltRequested(value)),
        decoration: InputDecoration(
          labelText: 'Album',
          hintText: 'Album of the song',
          suffixIcon: IconButton(
            onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(SaveAlbumAltRequested(_controller.text)),
            icon: const Icon(Icons.done),
          ),
        ),
      ),
    );
  }
}
