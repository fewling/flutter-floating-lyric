import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'window_settings_state.freezed.dart';

final windowSettingScreenStateProvider =
    NotifierProvider<WindowSettingNotifier, WindowSettingState>(WindowSettingNotifier.new);

class WindowSettingNotifier extends Notifier<WindowSettingState> {
  @override
  WindowSettingState build() => const WindowSettingState(panelIndexes: {});

  void togglePanel(int panelIndex) {
    final indexes = Set<int>.from(state.panelIndexes);
    if (state.panelIndexes.contains(panelIndex)) {
      state = state.copyWith(panelIndexes: indexes..remove(panelIndex));
    } else {
      state = state.copyWith(panelIndexes: indexes..add(panelIndex));
    }
  }
}

@freezed
class WindowSettingState with _$WindowSettingState {
  const factory WindowSettingState({
    required Set<int> panelIndexes,
  }) = _WindowSettingState;
}
