import 'package:freezed_annotation/freezed_annotation.dart';

part 'window_state.freezed.dart';
part 'window_state.g.dart';

@freezed
class WindowState with _$WindowState {
  const factory WindowState({
    @Default(false) bool isVisible,
    @Default('') String title,
    @Default('') String lyricLine,
    @Default(50.0) double opacity,
    @Default(255) int r,
    @Default(255) int g,
    @Default(255) int b,
    @Default(255) int a,
    @Default(0) int seekBarMax,
    @Default(0) int seekBarProgress,
    @Default(true) bool showMillis,
    @Default(true) bool showProgressBar,
    @Default(24) int fontSize,
    @Default(false) bool isLocked,
    @Default(false) bool isTouchThrough,
    @Default(false) bool ignoreTouch,
  }) = _WindowState;

  factory WindowState.fromJson(Map<String, dynamic> json) => _$WindowStateFromJson(json);
}
