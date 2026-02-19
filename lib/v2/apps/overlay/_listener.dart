part of 'overlay_app.dart';

class OverlayAppListener extends StatelessWidget {
  const OverlayAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MsgFromMainBloc, MsgFromMainState>(
          listenWhen: (previous, current) =>
              previous.mediaState != current.mediaState,
          listener: (context, state) {
            context.read<OverlayWindowBloc>().add(
              OverlayWindowEvent.mediaStateUpdated(state.mediaState),
            );

            context.read<LyricFinderBloc>().add(
              LyricFinderEvent.mediaStateUpdated(state.mediaState!),
            );
          },
        ),

        BlocListener<MsgFromMainBloc, MsgFromMainState>(
          listenWhen: (previous, current) =>
              previous.config != current.config && current.config != null,
          listener: (context, state) => context.read<OverlayWindowBloc>().add(
            OverlayWindowEvent.windowConfigsUpdated(state.config!),
          ),
        ),

        BlocListener<MsgFromMainBloc, MsgFromMainState>(
          listenWhen: (previous, current) =>
              previous.newLyricHandlingStatus !=
                  current.newLyricHandlingStatus &&
              current.newLyricHandlingStatus == NewLyricHandlingStatus.received,

          listener: (context, state) => context.read<LyricFinderBloc>().add(
            const LyricFinderEvent.reset(),
          ),
        ),

        BlocListener<LyricFinderBloc, LyricFinderState>(
          listenWhen: (previous, current) =>
              current.status == LyricFinderStatus.found &&
              previous.currentLrc != current.currentLrc,
          listener: (context, state) => context.read<OverlayWindowBloc>().add(
            OverlayWindowEvent.lyricFound(lrc: state.currentLrc!),
          ),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
