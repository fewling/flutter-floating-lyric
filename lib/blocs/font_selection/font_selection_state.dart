part of 'font_selection_bloc.dart';

@freezed
sealed class FontSelectionState with _$FontSelectionState {
  const factory FontSelectionState({
    @Default(<String, TextStyle>{}) Map<String, TextStyle> fontStyles,
    @Default(<String, TextStyle>{}) Map<String, TextStyle> filteredFontStyles,
    @Default(0) int offset,
    @Default(20) int limit,
  }) = _FontSelectionState;
}
