part of 'overlay_app_bloc.dart';

@freezed
sealed class OverlayAppEvent with _$OverlayAppEvent {
  const factory OverlayAppEvent.started() = _Started;

  const factory OverlayAppEvent.minimizeRequested() = _MinimizeRequested;

  const factory OverlayAppEvent.maximizeRequested() = _MaximizeRequested;
}
