import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/event_channels/media_states/media_state.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int currentIndex,
    @Default(null) MediaState? mediaState,
    @Default(false) bool isWindowVisible,
    @Default(false) bool isProcessingFiles,
    @Default(false) bool isSearchingOnline,
  }) = _HomeState;
}
