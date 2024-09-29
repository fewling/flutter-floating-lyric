import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_lyric_state.freezed.dart';
part 'overlay_window_lyric_state.g.dart';

@freezed
class OverlayWindowLyricState with _$OverlayWindowLyricState {
  const factory OverlayWindowLyricState({
    required String title,
    required String line1,
    required String line2,
    required String positionLeftLabel,
    required String positionRightLabel,
    required double position,
  }) = _OverlayWindowLyricState;

  factory OverlayWindowLyricState.fromJson(Map<String, dynamic> json) => _$OverlayWindowLyricStateFromJson(json);
}
