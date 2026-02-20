part of 'overlay_app.dart';

class OverlayAppListener extends StatelessWidget with OverlayWindowSizingMixin {
  const OverlayAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MsgFromMainBloc, MsgFromMainState>(
          listenWhen: (previous, current) =>
              previous.mediaState != current.mediaState,
          listener: (context, state) => context.read<OverlayWindowBloc>().add(
            OverlayWindowEvent.mediaStateUpdated(state.mediaState),
          ),
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
              previous.searchLyricStatus != current.searchLyricStatus,
          listener: (context, state) => context.read<OverlayWindowBloc>().add(
            OverlayWindowEvent.lyricStateUpdated(
              status: state.searchLyricStatus,
              lrc: state.currentLrc,
            ),
          ),
        ),

        BlocListener<OverlayAppBloc, OverlayAppState>(
          listenWhen: (previous, current) =>
              previous.isMinimized != current.isMinimized,
          listener: (context, state) => updateSize(context),
          child: Container(),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
