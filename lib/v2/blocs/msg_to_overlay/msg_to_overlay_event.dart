part of 'msg_to_overlay_bloc.dart';

@freezed
sealed class MsgToOverlayEvent with _$MsgToOverlayEvent {
  const factory MsgToOverlayEvent.onWindowSettingsUpdated(
    OverlaySettingsModel settings,
  ) = _WindowSettingsUpdated;

  const factory MsgToOverlayEvent.onMediaStateUpdated(MediaState mediaState) =
      _MediaStateUpdated;
}
