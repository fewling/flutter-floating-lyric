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
