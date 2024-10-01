import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_settings.freezed.dart';
part 'overlay_window_settings.g.dart';

@freezed
class OverlayWindowSettings with _$OverlayWindowSettings {
  const factory OverlayWindowSettings({
    // State
    @Default(false) bool isWindowVisible,

    // Data
    String? title,
    String? line1,
    String? line2,
    String? positionLeftLabel,
    String? positionRightLabel,
    double? position,

    // Styles
    @Default(300) int height,
    double? opacity,
    int? color,
    bool? showProgressBar,
    bool? showMillis,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
  }) = _OverlayWindowSettings;

  factory OverlayWindowSettings.fromJson(Map<String, dynamic> json) => _$OverlayWindowSettingsFromJson(json);
}
