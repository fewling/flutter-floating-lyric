part of 'overlay_window_bloc.dart';

@freezed
class OverlayWindowState with _$OverlayWindowState {
  const factory OverlayWindowState({
    @Default(OverlayWindowSettings()) OverlayWindowSettings settings,
  }) = _OverlayWindowState;

  factory OverlayWindowState.fromJson(Map<String, dynamic> json) => _$OverlayWindowStateFromJson(json);
}
