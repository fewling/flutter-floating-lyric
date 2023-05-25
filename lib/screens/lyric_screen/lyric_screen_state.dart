import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lrc.dart';

part 'lyric_screen_state.freezed.dart';

@freezed
class LyricScreenState with _$LyricScreenState {
  const factory LyricScreenState({
    required int currentStep,
    @Default(false) bool isFloatingWindowShown,
    @Default(false) bool isPlaying,
    @Default(0) double position,
    @Default(0) double duration,
    @Default('') String title,
    @Default('') String artist,
    @Default('') String mediaPlayerName,
    Lrc? currentLrc,
    @Default(false) bool isProcessingFiles,
  }) = _LyricScreenState;
}
