part of 'overlay_window_bloc.dart';

@freezed
class OverlayWindowState with _$OverlayWindowState {
  const factory OverlayWindowState({
    @Default(false) bool isLyricOnly,
    @Default(false) bool isLocked,
  }) = _OverlayWindowState;
}
