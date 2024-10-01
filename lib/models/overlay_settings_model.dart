import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_settings_model.freezed.dart';
part 'overlay_settings_model.g.dart';

@freezed
class OverlaySettingsModel with _$OverlaySettingsModel {
  const factory OverlaySettingsModel({
    // Data
    String? title,
    String? line1,
    String? line2,
    String? positionLeftLabel,
    String? positionRightLabel,
    double? position,

    // Styles
    double? opacity,
    int? color,
    bool? showProgressBar,
    bool? showMillis,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
  }) = _OverlaySettingsModel;

  factory OverlaySettingsModel.fromJson(Map<String, dynamic> json) => _$OverlaySettingsModelFromJson(json);
}
