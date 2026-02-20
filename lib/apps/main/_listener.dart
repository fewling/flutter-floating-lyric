part of 'main_app.dart';

class MainAppListener extends StatelessWidget {
  const MainAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PreferenceBloc, PreferenceState>(
          listener: (context, state) => context
              .read<OverlayWindowSettingsBloc>()
              .add(OverlayWindowSettingsEvent.preferenceUpdated(state)),
        ),

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

        BlocListener<OverlayWindowSettingsBloc, OverlayWindowSettingsState>(
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onWindowConfigUpdated(state.config),
          ),
        ),

        BlocListener<MediaListenerBloc, MediaListenerState>(
          listenWhen: (previous, current) =>
              previous.mediaStates != current.mediaStates &&
              current.activeMediaState != null,
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onMediaStateUpdated(state.activeMediaState!),
          ),
        ),

        BlocListener<MediaListenerBloc, MediaListenerState>(
          listener: (context, state) => context.read<LyricFinderBloc>().add(
            LyricFinderEvent.mediaStateUpdated(state.activeMediaState!),
          ),
        ),

        BlocListener<MsgFromOverlayBloc, MsgFromOverlayState>(
          listener: (context, state) {
            switch (state.msg) {
              case null:
                break;

              case CloseOverlay():
                context.read<OverlayWindowSettingsBloc>().add(
                  const OverlayWindowSettingsEvent.windowVisibilityToggled(
                    false,
                  ),
                );

              case MeasureScreenWidth():
                break;
            }

            context.read<MsgFromOverlayBloc>().add(
              const MsgFromOverlayEvent.handled(),
            );
          },
        ),

        BlocListener<SaveLrcBloc, SaveLrcState>(
          listener: (context, state) {
            switch (state.saveLrcStatus) {
              case SaveLrcStatus.initial:
                break;
              case SaveLrcStatus.loading:
                break;
              case SaveLrcStatus.success:
                context.showSnackBar(
                  message: context.l10n.fetch_online_lyric_saved,
                );

                // Reset lyric finder state
                context.read<LyricFinderBloc>().add(
                  const LyricFinderEvent.reset(),
                );

              case SaveLrcStatus.failure:
                context.showSnackBar(
                  message: context.l10n.fetch_online_failed_to_save_lyric,
                );
            }
          },
        ),

        BlocListener<LyricFinderBloc, LyricFinderState>(
          listener: (context, state) {
            switch (state.status) {
              case LyricFinderStatus.initial:
                break;

              case LyricFinderStatus.empty:
                context.read<MsgToOverlayBloc>().add(
                  const MsgToOverlayEvent.emptyLrc(),
                );

              case LyricFinderStatus.searching:
                context.read<MsgToOverlayBloc>().add(
                  const MsgToOverlayEvent.searchingLrc(),
                );

              case LyricFinderStatus.found:
                context.read<MsgToOverlayBloc>().add(
                  MsgToOverlayEvent.lrcFound(state.currentLrc!),
                );

              case LyricFinderStatus.notFound:
                context.read<MsgToOverlayBloc>().add(
                  const MsgToOverlayEvent.lyricNotFound(),
                );
            }
          },
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
