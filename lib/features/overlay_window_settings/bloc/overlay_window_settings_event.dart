part of 'overlay_window_settings_bloc.dart';

sealed class OverlayWindowSettingsEvent {
  const OverlayWindowSettingsEvent();
}

final class OverlayWindowSettingsLoaded extends OverlayWindowSettingsEvent {
  const OverlayWindowSettingsLoaded({
    required this.preferenceState,
    required this.lyricStateListenerState,
    required this.screenWidth,
  });

  final PreferenceState preferenceState;
  final LyricStateListenerState lyricStateListenerState;
  final double screenWidth;
}

final class PreferenceUpdated extends OverlayWindowSettingsEvent {
  const PreferenceUpdated({
    required this.preferenceState,
  });

  final PreferenceState preferenceState;
}

final class LyricStateListenerUpdated extends OverlayWindowSettingsEvent {
  const LyricStateListenerUpdated({
    required this.lyricStateListenerState,
  });

  final LyricStateListenerState lyricStateListenerState;
}

final class OverlayWindowVisibilityToggled extends OverlayWindowSettingsEvent {
  const OverlayWindowVisibilityToggled(this.shouldVisible);

  final bool shouldVisible;
}

final class LyricOnlyModeToggled extends OverlayWindowSettingsEvent {
  const LyricOnlyModeToggled();
}
