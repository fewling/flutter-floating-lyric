import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repos/local/local_db_repo.dart';
import '../../repos/remote/lrclib/lrclib_repository.dart';
import '../../service/db/local/local_db_service.dart';
import '../../service/lrc_lib/lrc_lib_service.dart';
import '../../utils/extensions/custom_extensions.dart';
import '../../widgets/loading_widget.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/fetch_online_lrc_form_bloc.dart';

class FetchOnlineLrcForm extends StatelessWidget {
  const FetchOnlineLrcForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) =>
          FetchOnlineLrcFormBloc(
            lrcLibService: LrcLibService(
              lrcLibRepository: context.read<LrcLibRepository>(),
            ),
            localDbService: LocalDbService(
              localDBRepo: context.read<LocalDbRepo>(),
            ),
          )..add(
            FetchOnlineLrcFormStarted(
              album: context
                  .read<LyricStateListenerBloc>()
                  .state
                  .mediaState
                  ?.album,
              artist: context
                  .read<LyricStateListenerBloc>()
                  .state
                  .mediaState
                  ?.artist,
              title: context
                  .read<LyricStateListenerBloc>()
                  .state
                  .mediaState
                  ?.title,
              duration: context
                  .read<LyricStateListenerBloc>()
                  .state
                  .mediaState
                  ?.duration,
            ),
          ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
            listenWhen: _coreLyricStateUpdated,
            listener: (context, state) =>
                context.read<FetchOnlineLrcFormBloc>().add(
                  NewSongPlayed(
                    title: state.mediaState?.title,
                    artist: state.mediaState?.artist,
                    album: state.mediaState?.album,
                    duration: state.mediaState?.duration,
                  ),
                ),
          ),
          BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
            listenWhen: (previous, current) =>
                previous.requestStatus != current.requestStatus,
            listener: (context, state) {
              final l10n = context.l10n;
              switch (state.requestStatus) {
                case OnlineLrcRequestStatus.initial:
                case OnlineLrcRequestStatus.loading:
                  break;
                case OnlineLrcRequestStatus.success:
                case OnlineLrcRequestStatus.failure:
                  final resp = state.lrcLibResponse;
                  final content =
                      resp?.syncedLyrics ??
                      resp?.plainLyrics ??
                      l10n.fetch_online_no_lyric_found;
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => BlocProvider.value(
                      value: context.read<FetchOnlineLrcFormBloc>(),
                      child: Theme(
                        data: Theme.of(context),
                        child: AlertDialog(
                          icon: const Icon(Icons.info_outline),
                          title: Text(l10n.fetch_online_lyric_fetch_result),
                          content: SelectableText(content),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogCtx).pop(),
                              child: Text(l10n.fetch_online_close),
                            ),
                            if (resp != null)
                              TextButton(
                                onPressed: () {
                                  context.read<FetchOnlineLrcFormBloc>().add(
                                    SaveLyricResponseRequested(resp),
                                  );
                                  Navigator.of(dialogCtx).pop();
                                },
                                child: Text(l10n.fetch_online_save),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                  context.read<FetchOnlineLrcFormBloc>().add(
                    const ErrorResponseHandled(),
                  );
                  break;
              }
            },
          ),
          BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
            listenWhen: (previous, current) =>
                previous.saveLrcStatus != current.saveLrcStatus,
            listener: (context, state) {
              final l10n = context.l10n;
              switch (state.saveLrcStatus) {
                case SaveLrcStatus.initial:
                case SaveLrcStatus.saving:
                  break;
                case SaveLrcStatus.success:
                  context.read<LyricStateListenerBloc>().add(
                    const NewLyricSaved(),
                  );
                case SaveLrcStatus.failure:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.saveLrcStatus.isSuccess
                            ? l10n.fetch_online_lyric_saved
                            : l10n.fetch_online_failed_to_save_lyric,
                      ),
                    ),
                  );
                  context.read<FetchOnlineLrcFormBloc>().add(
                    const SaveResponseHandled(),
                  );
              }
            },
          ),
        ],
        child: Scaffold(
          floatingActionButton: Builder(
            builder: (context) {
              final l10n = context.l10n;
              final isSearching = context.select<FetchOnlineLrcFormBloc, bool>(
                (bloc) => bloc.state.requestStatus.isLoading,
              );

              final noMediaState = context.select<LyricStateListenerBloc, bool>(
                (bloc) => bloc.state.mediaState == null,
              );

              final shouldDisable = isSearching || noMediaState;

              return FloatingActionButton.extended(
                onPressed: shouldDisable
                    ? null
                    : () => context.read<FetchOnlineLrcFormBloc>().add(
                        const SearchOnlineRequested(),
                      ),
                icon: isSearching
                    ? const LoadingWidget()
                    : const Icon(Icons.search),
                label: Text(l10n.fetch_online_search),
              );
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    final l10n = context.l10n;
                    final autoFetchOnline = context
                        .select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.autoFetchOnline,
                        );
                    return SwitchListTile(
                      title: Text(l10n.fetch_online_auto_fetch),
                      value: autoFetchOnline,
                      onChanged: (value) => context.read<PreferenceBloc>().add(
                        const AutoFetchOnlineToggled(),
                      ),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final l10n = context.l10n;
                    final isEditingTitle = context
                        .select<FetchOnlineLrcFormBloc, bool>(
                          (bloc) => bloc.state.isEditingTitle,
                        );
                    final title = context
                        .select<FetchOnlineLrcFormBloc, String?>(
                          (bloc) => bloc.state.titleAlt,
                        );

                    return isEditingTitle
                        ? TitleAltField(title: title)
                        : ListTile(
                            title: Text(l10n.fetch_online_title),
                            subtitle: Text(title ?? l10n.fetch_online_unknown),
                            onTap: () => context
                                .read<FetchOnlineLrcFormBloc>()
                                .add(const EditFieldRequested(isTitle: true)),
                            trailing: const Icon(Icons.edit_outlined),
                          );
                  },
                ),
                Builder(
                  builder: (context) {
                    final l10n = context.l10n;
                    final isEditingArtist = context
                        .select<FetchOnlineLrcFormBloc, bool>(
                          (bloc) => bloc.state.isEditingArtist,
                        );

                    final artist = context
                        .select<FetchOnlineLrcFormBloc, String?>(
                          (bloc) => bloc.state.artistAlt,
                        );

                    return isEditingArtist
                        ? ArtistAltField(artist: artist)
                        : ListTile(
                            title: Text(l10n.fetch_online_artist),
                            subtitle: Text(artist ?? l10n.fetch_online_unknown),
                            onTap: () => context
                                .read<FetchOnlineLrcFormBloc>()
                                .add(const EditFieldRequested(isArtist: true)),
                            trailing: const Icon(Icons.edit_outlined),
                          );
                  },
                ),
                Builder(
                  builder: (context) {
                    final l10n = context.l10n;
                    final isEditingAlbum = context
                        .select<FetchOnlineLrcFormBloc, bool>(
                          (bloc) => bloc.state.isEditingAlbum,
                        );

                    final album = context
                        .select<FetchOnlineLrcFormBloc, String?>(
                          (bloc) => bloc.state.albumAlt,
                        );

                    return isEditingAlbum
                        ? AlbumAltField(album: album)
                        : ListTile(
                            title: Text(l10n.fetch_online_album),
                            subtitle: Text(album ?? l10n.fetch_online_unknown),
                            onTap: () => context
                                .read<FetchOnlineLrcFormBloc>()
                                .add(const EditFieldRequested(isAlbum: true)),
                            trailing: const Icon(Icons.edit_outlined),
                          );
                  },
                ),
                ListTile(
                  title: Text(l10n.fetch_online_duration),
                  subtitle: Builder(
                    builder: (context) {
                      final l10n = context.l10n;
                      final millis = context
                          .select<LyricStateListenerBloc, int>(
                            (bloc) =>
                                bloc.state.mediaState?.duration.toInt() ?? 0,
                          );

                      final duration = Duration(milliseconds: millis);

                      return Text(duration.mmss());
                    },
                  ),
                ),
                Center(
                  child: Builder(
                    builder: (context) {
                      final l10n = context.l10n;
                      return RichText(
                        text: TextSpan(
                          text: l10n.fetch_online_powered_by,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                          children: [
                            TextSpan(
                              text: 'LrcLib',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrl(
                                  Uri.parse('https://lrclib.net'),
                                  mode: LaunchMode.externalApplication,
                                ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _coreLyricStateUpdated(
    LyricStateListenerState previous,
    LyricStateListenerState current,
  ) {
    final mediaState = current.mediaState;
    final isNewSong =
        previous.mediaState?.title != mediaState?.title ||
        previous.mediaState?.artist != mediaState?.artist ||
        previous.mediaState?.album != mediaState?.album ||
        previous.mediaState?.duration != mediaState?.duration;
    return isNewSong;
  }
}

class TitleAltField extends StatefulWidget {
  const TitleAltField({super.key, this.title});

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
    final l10n = context.l10n;
    return BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
      listenWhen: (previous, current) => previous.titleAlt != current.titleAlt,
      listener: (context, state) {
        if (state.titleAlt == null) {
          _controller.clear();
        } else if (state.titleAlt != _controller.text) {
          _controller.text = state.titleAlt!;
        }
      },
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(
          SaveTitleAltRequested(value),
        ),
        decoration: InputDecoration(
          labelText: l10n.fetch_online_title,
          hintText: l10n.fetch_online_title_hint,
          suffixIcon: IconButton(
            onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(
              SaveTitleAltRequested(_controller.text),
            ),
            icon: const Icon(Icons.done),
          ),
        ),
      ),
    );
  }
}

class ArtistAltField extends StatefulWidget {
  const ArtistAltField({super.key, this.artist});

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
    final l10n = context.l10n;
    return BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
      listenWhen: (previous, current) =>
          previous.artistAlt != current.artistAlt,
      listener: (context, state) {
        if (state.artistAlt == null) {
          _controller.clear();
        } else if (state.artistAlt != _controller.text) {
          setState(() {
            _controller.text = state.artistAlt!;
          });
        }
      },
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(
          SaveArtistAltRequested(value),
        ),
        decoration: InputDecoration(
          labelText: l10n.fetch_online_artist,
          hintText: l10n.fetch_online_artist_hint,
          suffixIcon: IconButton(
            onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(
              SaveArtistAltRequested(_controller.text),
            ),
            icon: const Icon(Icons.done),
          ),
        ),
      ),
    );
  }
}

class AlbumAltField extends StatefulWidget {
  const AlbumAltField({super.key, this.album});

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
    final l10n = context.l10n;
    return BlocListener<FetchOnlineLrcFormBloc, FetchOnlineLrcFormState>(
      listenWhen: (previous, current) => previous.albumAlt != current.albumAlt,
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
        onFieldSubmitted: (value) => context.read<FetchOnlineLrcFormBloc>().add(
          SaveAlbumAltRequested(value),
        ),
        decoration: InputDecoration(
          labelText: l10n.fetch_online_album,
          hintText: l10n.fetch_online_album_hint,
          suffixIcon: IconButton(
            onPressed: () => context.read<FetchOnlineLrcFormBloc>().add(
              SaveAlbumAltRequested(_controller.text),
            ),
            icon: const Icon(Icons.done),
          ),
        ),
      ),
    );
  }
}
