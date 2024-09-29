import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_style_state.freezed.dart';
part 'overlay_window_style_state.g.dart';

@freezed
class OverlayWindowStyleState with _$OverlayWindowStyleState {
  const factory OverlayWindowStyleState({
    required double height,
    required double fontSize,
    required double lineHeight,
    required double letterSpacing,
  }) = _OverlayWindowStyleState;

  factory OverlayWindowStyleState.fromJson(Map<String, dynamic> json) => _$OverlayWindowStyleStateFromJson(json);
}
