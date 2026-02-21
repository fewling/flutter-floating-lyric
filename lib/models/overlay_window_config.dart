// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_locale.dart';

part 'overlay_window_config.freezed.dart';
part 'overlay_window_config.g.dart';

@freezed
sealed class OverlayWindowConfig with _$OverlayWindowConfig {
  const factory OverlayWindowConfig({
    // Themes:
    @Default(false) bool isLight,
    @Default(0) int appColorScheme,

    @JsonKey(fromJson: appLocaleFromJson, toJson: appLocaleToJson)
    @Default(AppLocale.english)
    AppLocale locale,

    double? tolerance,

    // Styles
    @Default(true) bool useAppColor,
    double? opacity,
    int? color,
    int? backgroundColor,
    bool? showProgressBar,
    bool? showMillis,
    int? visibleLinesCount,
    @Default('') String fontFamily,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    @Default(false) bool enableAnimation,
    @Default(false) bool transparentNotFoundTxt,

    // Settings
    bool? ignoreTouch,
    bool? touchThru,
  }) = _OverlayWindowConfig;

  factory OverlayWindowConfig.fromJson(Map<String, dynamic> json) =>
      _$OverlayWindowConfigFromJson(json);
}
