part of 'overlay_window_settings_bloc.dart';

@freezed
sealed class OverlayWindowSettingsState with _$OverlayWindowSettingsState {
  const factory OverlayWindowSettingsState({
    required OverlaySettingsModel settings,
    @Default(false) bool isWindowVisible,
  }) = _OverlayWindowSettingsState;
}
