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
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onMediaStateUpdated(state.activeMediaState!),
          ),
        ),

        BlocListener<MediaListenerBloc, MediaListenerState>(
          listenWhen: (previous, current) {
            final prev = previous.activeMediaState;
            final curr = current.activeMediaState;

            final isNewSong = switch (prev?.isSameMedia(curr)) {
              null || false => true,
              true => false,
            };
            return isNewSong && curr != null;
          },
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
          listenWhen: (previous, current) =>
              previous.currentLrc != current.currentLrc ||
              previous.status != current.status,
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.lrcStateUpdated(
              lrc: state.currentLrc,
              searchStatus: state.status,
            ),
          ),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
