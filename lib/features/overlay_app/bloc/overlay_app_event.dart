part of 'overlay_app_bloc.dart';

sealed class OverlayAppEvent {
  const OverlayAppEvent();
}

final class OverlayAppStarted extends OverlayAppEvent {
  const OverlayAppStarted();
}

final class MinimizeRequested extends OverlayAppEvent {
  const MinimizeRequested();
}

final class MaximizeRequested extends OverlayAppEvent {
  const MaximizeRequested();
}
