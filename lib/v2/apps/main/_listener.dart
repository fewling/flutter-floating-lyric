part of 'main_app.dart';

class MainAppListener extends StatelessWidget {
  const MainAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OverlayWindowSettingsBloc, OverlayWindowSettingsState>(
          listener: (context, state) => context.read<MsgToOverlayBloc>().add(
            MsgToOverlayEvent.onWindowSettingsUpdated(state.settings),
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
      ],
      child: Builder(builder: builder),
    );
  }
}
