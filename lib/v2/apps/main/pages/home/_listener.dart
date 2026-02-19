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
      ],
      child: Builder(builder: builder),
    );
  }
}
