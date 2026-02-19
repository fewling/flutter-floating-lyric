part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OverlayWindowSettingsBloc, OverlayWindowSettingsState>(
          listenWhen: (previous, current) =>
              previous.isWindowVisible != current.isWindowVisible &&
              current.isWindowVisible,
          listener: (context, state) =>
              context.read<OverlayWindowSettingsBloc>().add(
                OverlayWindowSettingsEvent.preferenceUpdated(
                  context.read<PreferenceBloc>().state,
                ),
              ),
        ),

        BlocListener<MediaListenerBloc, MediaListenerState>(
          listenWhen: (previous, current) {
            final mediaState = current.activeMediaState;
            final isNewSong =
                previous.activeMediaState?.title != mediaState?.title ||
                previous.activeMediaState?.artist != mediaState?.artist ||
                previous.activeMediaState?.album != mediaState?.album ||
                previous.activeMediaState?.duration != mediaState?.duration;
            return isNewSong;
          },
          listener: (context, state) =>
              context.read<FetchOnlineLrcFormBloc>().add(
                NewSongPlayed(
                  title: state.activeMediaState?.title,
                  artist: state.activeMediaState?.artist,
                  album: state.activeMediaState?.album,
                  duration: state.activeMediaState?.duration,
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
                context.read<MsgToOverlayBloc>().add(
                  const MsgToOverlayEvent.newLyricSaved(),
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
      child: Builder(builder: builder),
    );
  }
}
