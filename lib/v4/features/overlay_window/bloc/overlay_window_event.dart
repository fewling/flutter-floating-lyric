part of 'overlay_window_bloc.dart';

sealed class OverlayWindowEvent {
  const OverlayWindowEvent();
}

final class OverlayWindowLoaded extends OverlayWindowEvent {
  const OverlayWindowLoaded();
}

final class OverlayWindowToggled extends OverlayWindowEvent {
  const OverlayWindowToggled();
}

final class OverlayWindowSizeChanged extends OverlayWindowEvent {
  const OverlayWindowSizeChanged();
}

final class LyricStateUpdated extends OverlayWindowEvent {
  const LyricStateUpdated({
    required this.title,
    required this.line1,
    required this.line2,
    required this.positionLeftLabel,
    required this.positionRightLabel,
    required this.position,
  });

  final String title;
  final String line1;
  final String line2;
  final String positionLeftLabel;
  final String positionRightLabel;
  final double position;
}

final class WindowStyleUpdated extends OverlayWindowEvent {
  const WindowStyleUpdated({
    required this.opacity,
    required this.color,
    required this.fontSize,
    required this.showProgressBar,
    required this.showMillis,
  });

  final double opacity;
  final int color;
  final int fontSize;
  final bool showProgressBar;
  final bool showMillis;
}
