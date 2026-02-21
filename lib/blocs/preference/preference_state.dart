part of 'preference_bloc.dart';

@freezed
sealed class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    required double opacity,
    required int color,
    required int backgroundColor,
    required bool isLight,
    required int appColorScheme,
    required bool showMilliseconds,
    required bool showProgressBar,
    required String fontFamily,
    required int fontSize,
    required bool autoFetchOnline,
    required int visibleLinesCount,
    required bool useAppColor,
    required bool transparentNotFoundTxt,
    required int tolerance,
    required bool windowIgnoreTouch,

    @JsonKey(fromJson: appLocaleFromJson, toJson: appLocaleToJson)
    @Default(AppLocale.english)
    AppLocale locale,
  }) = _PreferenceState;
}
