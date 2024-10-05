part of 'overlay_window_settings_bloc.dart';

@freezed
class OverlayWindowSettingsState with _$OverlayWindowSettingsState {
  const factory OverlayWindowSettingsState({
    @Default(false) bool isWindowVisible,
    @Default(OverlaySettingsModel()) OverlaySettingsModel settings,
  }) = _OverlayWindowSettingsState;

  factory OverlayWindowSettingsState.fromJson(Map<String, dynamic> json) => _$OverlayWindowSettingsStateFromJson(json);
}
