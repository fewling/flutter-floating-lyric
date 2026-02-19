part of 'shell.dart';

const _minimizedSize = 48.0;

class _View extends StatelessWidget {
  const _View({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateSize(context);
        return child;
      },
    );
  }

  void _updateSize(BuildContext context) {
    final isMinimized = context.read<OverlayAppBloc>().state.isMinimized;

    const screenWidth = 300.0;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.e('Root box is null. Cannot update size.');
        context.read<OverlayWindowBloc>().add(
          const OverlayWindowEvent.windowResized(width: 50, height: 50),
        );
        return;
      }

      final view = View.of(context);
      final pxRatio = view.devicePixelRatio;

      final width = isMinimized
          ? _minimizedSize
          : (screenWidth > 0 ? screenWidth : 300.0);
      final height = box.getMaxIntrinsicHeight(width);

      context.read<OverlayWindowBloc>().add(
        OverlayWindowEvent.windowResized(
          width: (width + 0.3) * pxRatio,
          height: (height + 6) * pxRatio,
        ),
      );
    });
  }
}
