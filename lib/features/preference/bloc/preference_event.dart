part of 'preference_bloc.dart';

sealed class PreferenceEvent {
  const PreferenceEvent();
}

final class PreferenceEventLoad extends PreferenceEvent {
  const PreferenceEventLoad();
}

final class OpacityUpdated extends PreferenceEvent {
  const OpacityUpdated(this.value);

  final double value;
}

final class ColorUpdated extends PreferenceEvent {
  const ColorUpdated(this.color);

  final Color color;
}

final class BackgroundColorUpdated extends PreferenceEvent {
  const BackgroundColorUpdated(this.color);

  final Color color;
}

final class BrightnessToggled extends PreferenceEvent {
  const BrightnessToggled();
}

final class AppColorSchemeUpdated extends PreferenceEvent {
  const AppColorSchemeUpdated(this.color);

  final Color color;
}

final class ShowMillisecondsToggled extends PreferenceEvent {
  const ShowMillisecondsToggled();
}

final class ShowProgressBarToggled extends PreferenceEvent {
  const ShowProgressBarToggled();
}

final class ShowLine2Toggled extends PreferenceEvent {
  const ShowLine2Toggled();
}

final class FontSizeUpdated extends PreferenceEvent {
  const FontSizeUpdated(this.fontSize);

  final int fontSize;
}

final class AutoFetchOnlineToggled extends PreferenceEvent {
  const AutoFetchOnlineToggled();
}

final class WindowColorThemeToggled extends PreferenceEvent {
  const WindowColorThemeToggled(this.useAppColor);

  final bool useAppColor;
}

final class FontFamilyUpdated extends PreferenceEvent {
  const FontFamilyUpdated(this.fontFamily);

  final String fontFamily;
}

final class FontFamilyReset extends PreferenceEvent {
  const FontFamilyReset();
}

final class EnableAnimationToggled extends PreferenceEvent {
  const EnableAnimationToggled();
}

final class ToleranceUpdated extends PreferenceEvent {
  const ToleranceUpdated(this.tolerance);

  final int tolerance;
}

final class AnimationModeUpdated extends PreferenceEvent {
  const AnimationModeUpdated(this.mode);

  final AnimationMode mode;
}

final class TransparentNotFoundTxtToggled extends PreferenceEvent {
  const TransparentNotFoundTxtToggled(this.transparentNotFoundTxt);

  final bool transparentNotFoundTxt;
}
