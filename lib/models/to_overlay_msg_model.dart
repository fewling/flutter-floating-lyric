import 'package:freezed_annotation/freezed_annotation.dart';

import '../service/event_channels/media_states/media_state.dart';
import '../v2/models/overlay_window_config.dart';

part 'to_overlay_msg_model.freezed.dart';
part 'to_overlay_msg_model.g.dart';

@freezed
sealed class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel.config(OverlayWindowConfig config) =
      ToOverlayMsgConfig;

  const factory ToOverlayMsgModel.mediaState(MediaState mediaState) =
      ToOverlayMsgMediaState;

  const factory ToOverlayMsgModel.newLyricSaved() = ToOverlayMsgNewLyricSaved;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
