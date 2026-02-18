part of 'preference_bloc.dart';

@freezed
sealed class PreferenceEvent with _$PreferenceEvent {
  const factory PreferenceEvent.started() = _Started;
  const factory PreferenceEvent.localeUpdated(AppLocale locale) =
      _LocaleUpdated;
}
