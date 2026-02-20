part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                  builder: (dialogCtx) => AlertDialog(
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
                            MainAppDependency.of(context)
                                .read<SaveLrcBloc>()
                                .add(SaveLrcEvent.saveOnlineLrcResponse(resp));
                            Navigator.of(dialogCtx).pop();
                          },
                          child: Text(l10n.fetch_online_save),
                        ),
                    ],
                  ),
                );
                context.read<FetchOnlineLrcFormBloc>().add(
                  const ErrorResponseHandled(),
                );
            }
          },
        ),

        BlocListener<LocalLrcPickerBloc, LocalLrcPickerState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case ImportLocalLrcStatus.initial:
              case ImportLocalLrcStatus.loading:
                break;
              case ImportLocalLrcStatus.success:
              case ImportLocalLrcStatus.failed:
                if (state.availableLrcs.isNotEmpty) {
                  MainAppDependency.of(context).read<SaveLrcBloc>().add(
                    SaveLrcEvent.saveLocalLrc(state.availableLrcs),
                  );
                }

                if (state.failedFiles.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => FailedImportDialog(state.failedFiles),
                  );
                }
            }
          },
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
