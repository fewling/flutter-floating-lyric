import 'package:freezed_annotation/freezed_annotation.dart';

import 'overlay_settings_model.dart';

part 'to_overlay_msg_model.freezed.dart';
part 'to_overlay_msg_model.g.dart';

@freezed
class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel({OverlaySettingsModel? settings}) =
      _ToOverlayMsgModel;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
