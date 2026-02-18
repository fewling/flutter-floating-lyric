part of 'overlay_window_settings_bloc.dart';

@freezed
sealed class OverlayWindowSettingsEvent with _$OverlayWindowSettingsEvent {
  const factory OverlayWindowSettingsEvent.windowVisibilityToggled(
    bool isVisible,
  ) = _WindowVisibilityToggled;

  const factory OverlayWindowSettingsEvent.windowIgnoreTouchToggled(
    bool value,
  ) = _WindowIgnoreTouchToggled;

  const factory OverlayWindowSettingsEvent.windowTouchThroughToggled(
    bool value,
  ) = _WindowTouchThroughToggled;
}
