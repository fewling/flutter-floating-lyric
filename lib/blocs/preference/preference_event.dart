part of 'preference_bloc.dart';

@freezed
sealed class PreferenceEvent with _$PreferenceEvent {
  const factory PreferenceEvent.started() = _Started;

  const factory PreferenceEvent.localeUpdated(AppLocale locale) =
      _LocaleUpdated;

  const factory PreferenceEvent.windowColorThemeToggled(bool value) =
      _WindowColorThemeToggled;

  const factory PreferenceEvent.backgroundColorUpdated(int color) =
      _BackgroundColorUpdated;

  const factory PreferenceEvent.opacityUpdated(double opacity) =
      _OpacityUpdated;

  const factory PreferenceEvent.fontSizeUpdated(double fontSize) =
      _FontSizeUpdated;

  const factory PreferenceEvent.colorUpdated(int color) = _ColorUpdated;

  const factory PreferenceEvent.showMillisecondsToggled(bool value) =
      _ShowMillisecondsToggled;

  const factory PreferenceEvent.showProgressBarToggled(bool value) =
      _ShowProgressBarToggled;

  const factory PreferenceEvent.transparentNotFoundTxtToggled(bool value) =
      _TransparentNotFoundTxtToggled;

  const factory PreferenceEvent.visibleLinesCountUpdated(int count) =
      _VisibleLinesCountUpdated;

  const factory PreferenceEvent.toleranceUpdated(int tolerance) =
      _ToleranceUpdated;

  const factory PreferenceEvent.windowIgnoreTouchToggled(bool value) =
      _WindowIgnoreTouchToggled;

  const factory PreferenceEvent.windowTouchThroughToggled(bool value) =
      _WindowTouchThroughToggled;

  const factory PreferenceEvent.autoFetchOnlineToggled() =
      _AutoFetchOnlineToggled;

  const factory PreferenceEvent.brightnessToggled() = _BrightnessToggled;

  const factory PreferenceEvent.appColorSchemeUpdated(int color) =
      _AppColorSchemeUpdated;

  const factory PreferenceEvent.fontFamilyUpdated(String key) =
      _FontFamilyUpdated;

  const factory PreferenceEvent.fontFamilyReset() = _FontFamilyReset;

  const factory PreferenceEvent.lyricAlignmentUpdated(
    LyricAlignment alignment,
  ) = _LyricAlignmentUpdated;
}
