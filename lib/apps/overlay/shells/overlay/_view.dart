part of 'shell.dart';

const _minimizedSize = 48.0;

class _View extends StatelessWidget {
  const _View({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMinimized = OverlayAppDependency.of(
      context,
    ).select((OverlayAppBloc bloc) => bloc.state.isMinimized);

    final appColor = OverlayAppDependency.of(
      context,
    ).select((MsgFromMainBloc bloc) => bloc.state.config?.appColorScheme);

    return switch (isMinimized) {
      false => child,
      true => SizedBox(
        width: _minimizedSize,
        height: _minimizedSize,
        child: Material(
          color: Color(
            appColor ?? Colors.purple.toARGB32(),
          ).withTransparency(0.25),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.read<OverlayAppBloc>().add(
              const OverlayAppEvent.maximizeRequested(),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.music_note_outlined),
            ),
          ),
        ),
      ),
    };
  }
}
