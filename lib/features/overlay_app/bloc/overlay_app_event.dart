part of 'overlay_app_bloc.dart';

sealed class OverlayAppEvent {
  const OverlayAppEvent();
}

final class OverlayAppStarted extends OverlayAppEvent {
  const OverlayAppStarted();
}

final class CloseRequested extends OverlayAppEvent {
  const CloseRequested();
}

final class WindowTouched extends OverlayAppEvent {
  const WindowTouched();
}

final class WindowResized extends OverlayAppEvent {
  const WindowResized({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
}

final class WindowMoved extends OverlayAppEvent {
  const WindowMoved({
    required this.dy,
  });

  final double dy;
}
