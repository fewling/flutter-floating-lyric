import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int currentIndex,
    @Default(false) bool isPlaying,
    @Default(null) String? title,
    @Default(null) String? artist,
    @Default(null) String? album,
    @Default(null) String? mediaAppName,
    @Default(0.0) double progress,
    @Default(false) bool isWindowVisible,
    @Default(false) bool isProcessingFiles,
  }) = _HomeState;
}
