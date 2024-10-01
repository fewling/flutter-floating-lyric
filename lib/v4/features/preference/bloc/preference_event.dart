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

final class BrightnessToggled extends PreferenceEvent {
  const BrightnessToggled();
}

final class AppColorSchemeUpdated extends PreferenceEvent {
  const AppColorSchemeUpdated(this.colorValue);

  final int colorValue;
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
