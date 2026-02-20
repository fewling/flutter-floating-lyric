part of 'msg_to_overlay_bloc.dart';

@freezed
sealed class MsgToOverlayEvent with _$MsgToOverlayEvent {
  const factory MsgToOverlayEvent.onWindowConfigUpdated(
    OverlayWindowConfig config,
  ) = _WindowConfigsUpdated;

  const factory MsgToOverlayEvent.onMediaStateUpdated(MediaState mediaState) =
      _MediaStateUpdated;

  const factory MsgToOverlayEvent.searchingLrc() = _SearchingLrc;

  const factory MsgToOverlayEvent.lrcFound(Lrc lrc) = _LrcFound;

  const factory MsgToOverlayEvent.emptyLrc() = _EmptyLrc;

  const factory MsgToOverlayEvent.lyricNotFound() = _LyricNotFound;
}
