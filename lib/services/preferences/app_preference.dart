import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preference.freezed.dart';
part 'app_preference.g.dart';

@freezed
class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    required double opacity,
    required int color,
    required bool isLight,
    required int appColorScheme,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) =>
      _$PreferenceStateFromJson(json);
}
