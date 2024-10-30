part of 'preference_bloc.dart';

@freezed
class PreferenceState with _$PreferenceState {
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
    required bool showLine2,
    required bool useAppColor,
    required bool enableAnimation,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) => _$PreferenceStateFromJson(json);
}
