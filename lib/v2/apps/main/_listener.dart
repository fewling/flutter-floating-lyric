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
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onWindowConfigUpdated(state.config),
          ),
        ),
        BlocListener<MediaListenerBloc, MediaListenerState>(
          listenWhen: (previous, current) =>
              previous.mediaStates != current.mediaStates &&
              current.mediaStates.any((mediaState) => mediaState.isPlaying) &&
              current.mediaStates.isNotEmpty,
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onMediaStateUpdated(
              state.mediaStates.firstWhere(
                (mediaState) => mediaState.isPlaying,
                orElse: () => state.mediaStates.first,
              ),
            ),
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
      ],
      child: Builder(builder: builder),
    );
  }
}
