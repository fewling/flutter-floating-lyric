part of 'font_select_bloc.dart';

@freezed
class FontSelectState with _$FontSelectState {
  const factory FontSelectState({
    @Default(<String, TextStyle>{}) Map<String, TextStyle> fontStyles,
    @Default(<String, TextStyle>{}) Map<String, TextStyle> filteredFontStyles,
  }) = _FontSelectState;
}
