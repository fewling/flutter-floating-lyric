import 'package:freezed_annotation/freezed_annotation.dart';

import '../service/event_channels/media_states/media_state.dart';
import 'overlay_settings_model.dart';

part 'to_overlay_msg_model.freezed.dart';
part 'to_overlay_msg_model.g.dart';

@freezed
sealed class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel.settings(OverlaySettingsModel settings) =
      ToOverlayMsgSettings;

  const factory ToOverlayMsgModel.mediaState(MediaState mediaState) =
      ToOverlayMsgMediaState;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
