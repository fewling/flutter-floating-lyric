part of 'overlay_window_bloc.dart';

@freezed
class OverlayWindowState with _$OverlayWindowState {
  const factory OverlayWindowState({
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

    // Device
    required double devicePixelRatio,
  }) = _OverlayWindowState;

  factory OverlayWindowState.fromJson(Map<String, dynamic> json) => _$OverlayWindowStateFromJson(json);
}
