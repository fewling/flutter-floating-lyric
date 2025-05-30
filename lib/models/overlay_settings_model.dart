import 'package:freezed_annotation/freezed_annotation.dart';

import '../configs/animation_modes.dart';
import '../configs/main_overlay/search_lyric_status.dart';
import 'lrc.dart';

part 'overlay_settings_model.freezed.dart';
part 'overlay_settings_model.g.dart';

@freezed
class OverlaySettingsModel with _$OverlaySettingsModel {
  const factory OverlaySettingsModel({
    // Themes:
    @Default(false) bool isLight,
    @Default(0) int appColorScheme,

    /// Screen width
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
    @Default(true) bool useAppColor,
    double? opacity,
    int? color,
    int? backgroundColor,
    bool? showProgressBar,
    bool? showMillis,
    bool? showLine2,
    @Default('') String fontFamily,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    @Default(false) bool enableAnimation,

    //
    @JsonKey(fromJson: animationModeFromJson, toJson: animationModeToJson)
    @Default(AnimationMode.fadeIn)
    AnimationMode animationMode,

    // Settings
    bool? ignoreTouch,
    bool? touchThru,
    @JsonKey(
      fromJson: searchLyricStatusFromJson,
      toJson: searchLyricStatusToJson,
    )
    @Default(SearchLyricStatus.initial)
    SearchLyricStatus searchLyricStatus,
  }) = _OverlaySettingsModel;

  factory OverlaySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$OverlaySettingsModelFromJson(json);
}
