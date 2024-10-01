part of 'overlay_window_settings_bloc.dart';

@freezed
class OverlayWindowSettingsEvent with _$OverlayWindowSettingsEvent {
  const factory OverlayWindowSettingsEvent.started() = _Started;
}