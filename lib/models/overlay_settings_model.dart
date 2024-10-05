import 'package:freezed_annotation/freezed_annotation.dart';

import 'lrc.dart';

part 'overlay_settings_model.freezed.dart';
part 'overlay_settings_model.g.dart';

@freezed
class OverlaySettingsModel with _$OverlaySettingsModel {
  const factory OverlaySettingsModel({
    // Themes:
    @Default(false) bool isLight,
    @Default(0) int appColorScheme,
    @Default(300) double width,

    // Data
    String? title,
    LrcLine? line1,
    LrcLine? line2,
    // String? positionLeftLabel,
    // String? positionRightLabel,
    double? position,
    double? duration,

    // Styles
    double? opacity,
    int? color,
    bool? showProgressBar,
    bool? showMillis,
    bool? showLine2,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,

    // Settings
    bool? ignoreTouch,
    bool? touchThru,
  }) = _OverlaySettingsModel;

  factory OverlaySettingsModel.fromJson(Map<String, dynamic> json) => _$OverlaySettingsModelFromJson(json);
}
