part of 'overlay_window_bloc.dart';

sealed class OverlayWindowEvent {
  const OverlayWindowEvent();
}

final class OverlayWindowStarted extends OverlayWindowEvent {
  const OverlayWindowStarted();
}

final class CloseRequested extends OverlayWindowEvent {
  const CloseRequested();
}

final class WindowResized extends OverlayWindowEvent {
  const WindowResized({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
}

final class WindowTapped extends OverlayWindowEvent {
  const WindowTapped();
}

final class LockToggled extends OverlayWindowEvent {
  const LockToggled();
}
