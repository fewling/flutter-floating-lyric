import 'package:freezed_annotation/freezed_annotation.dart';

part 'floating_window_state.freezed.dart';

@freezed
class FloatingWindowState with _$FloatingWindowState {
  const factory FloatingWindowState({
    required bool isVisible,
  }) = _FloatingWindowState;
}
