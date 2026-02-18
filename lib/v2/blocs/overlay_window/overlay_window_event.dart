part of 'overlay_window_bloc.dart';

@freezed
sealed class OverlayWindowEvent with _$OverlayWindowEvent {
  const factory OverlayWindowEvent.started() = _Started;

  const factory OverlayWindowEvent.closeRequested() = _CloseRequested;

  const factory OverlayWindowEvent.windowResized({
    required double width,
    required double height,
  }) = _WindowResized;

  const factory OverlayWindowEvent.windowTapped() = _WindowTapped;

  const factory OverlayWindowEvent.lockToggled(bool isLocked) = _LockToggled;

  const factory OverlayWindowEvent.screenWidthRequested() =
      _ScreenWidthRequested;
}
