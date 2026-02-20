import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/search_lyric_status.dart';
import 'lrc.dart';
import 'media_state.dart';
import 'overlay_window_config.dart';

part 'to_overlay_msg_model.freezed.dart';
part 'to_overlay_msg_model.g.dart';

@freezed
sealed class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel.config(OverlayWindowConfig config) =
      ToOverlayMsgConfig;

  const factory ToOverlayMsgModel.mediaState(MediaState mediaState) =
      ToOverlayMsgMediaState;

  const factory ToOverlayMsgModel.lrcState({
    required SearchLyricStatus searchLyricStatus,
    Lrc? lrc,
  }) = ToOverlayMsgLrcState;

  const factory ToOverlayMsgModel.deviceWidth(double width) =
      ToOverlayMsgDeviceWidth;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
