part of 'font_select_bloc.dart';

@freezed
sealed class FontSelectState with _$FontSelectState {
  const factory FontSelectState({
    @Default(<String, TextStyle>{}) Map<String, TextStyle> fontStyles,
    @Default(<String, TextStyle>{}) Map<String, TextStyle> filteredFontStyles,
    @Default(0) int offset,
    @Default(20) int limit,
  }) = _FontSelectState;
}
