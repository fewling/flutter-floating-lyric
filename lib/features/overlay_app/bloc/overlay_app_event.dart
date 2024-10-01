part of 'overlay_app_bloc.dart';

sealed class OverlayAppEvent {
  const OverlayAppEvent();
}

final class OverlayAppStarted extends OverlayAppEvent {
  const OverlayAppStarted();
}
