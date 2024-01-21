import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/lrc.dart';

part 'home_screen_state.freezed.dart';

@freezed
class HomeScreenState with _$HomeScreenState {
  const factory HomeScreenState({
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
  }) = _HomeScreenState;
}
