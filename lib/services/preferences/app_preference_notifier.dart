import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preference.dart';

part 'app_preference_notifier.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreference(SharedPreferenceRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
class PreferenceNotifier extends _$PreferenceNotifier {
  static const windowOpacityKey = 'window opacity';
  static const windowColorKey = 'window color';
  static const brightnessKey = 'brightness';
  static const appColorSchemeKey = 'app color scheme';
  static const showMillisecondsKey = 'show milliseconds';
  static const showProgressBarKey = 'show progress bar';
  static const fontSizeKey = 'font size';

  @override
  PreferenceState build() {
    final sp = ref.watch(sharedPreferenceProvider);

    return PreferenceState(
      opacity: sp.getDouble(windowOpacityKey) ?? 50,
      color: sp.getInt(windowColorKey) ?? Colors.deepPurple.value,
      isLight: sp.getBool(brightnessKey) ?? true,
      appColorScheme: sp.getInt(appColorSchemeKey) ?? Colors.deepPurple.value,
      showMilliseconds: sp.getBool(showMillisecondsKey) ?? true,
      showProgressBar: sp.getBool(showProgressBarKey) ?? true,
      fontSize: sp.getInt(fontSizeKey) ?? 24,
    );
  }

  void updateOpacity(double value) => ref
      .read(sharedPreferenceProvider)
      .setDouble(windowOpacityKey, value)
      .then((result) => state = state.copyWith(opacity: value));

  void updateColor(Color color) => ref
      .read(sharedPreferenceProvider)
      .setInt(windowColorKey, color.value)
      .then((value) => state = state.copyWith(color: color.value));

  void toggleBrightness() => ref
      .read(sharedPreferenceProvider)
      .setBool(brightnessKey, !state.isLight)
      .then((value) => state = state.copyWith(isLight: !state.isLight));

  void updateAppColorScheme(int colorValue) => ref
      .read(sharedPreferenceProvider)
      .setInt(appColorSchemeKey, colorValue)
      .then((value) => state = state.copyWith(appColorScheme: colorValue));

  void toggleShowMilliseconds() => ref
      .read(sharedPreferenceProvider)
      .setBool(showMillisecondsKey, !state.showMilliseconds)
      .then((value) =>
          state = state.copyWith(showMilliseconds: !state.showMilliseconds));

  void toggleShowProgressBar() => ref
      .read(sharedPreferenceProvider)
      .setBool(showProgressBarKey, !state.showProgressBar)
      .then((value) =>
          state = state.copyWith(showProgressBar: !state.showProgressBar));

  void updateFontSize(int fontSize) => ref
      .read(sharedPreferenceProvider)
      .setInt(fontSizeKey, fontSize)
      .then((result) => state = state.copyWith(fontSize: fontSize));
}
