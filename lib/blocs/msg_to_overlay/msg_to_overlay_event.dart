part of 'msg_to_overlay_bloc.dart';

@freezed
sealed class MsgToOverlayEvent with _$MsgToOverlayEvent {
  const factory MsgToOverlayEvent.onWindowConfigUpdated(
    OverlayWindowConfig config,
  ) = _WindowConfigsUpdated;

  const factory MsgToOverlayEvent.onMediaStateUpdated(MediaState mediaState) =
      _MediaStateUpdated;

  const factory MsgToOverlayEvent.lrcStateUpdated({
    required Lrc? lrc,
    required SearchLyricStatus searchStatus,
  }) = _LrcStateUpdated;
}
