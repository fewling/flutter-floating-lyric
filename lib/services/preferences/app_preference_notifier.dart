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

  @override
  PreferenceState build() {
    final sp = ref.watch(sharedPreferenceProvider);

    return PreferenceState(
      opacity: sp.getDouble(windowOpacityKey) ?? 50,
      color: sp.getInt(windowColorKey) ?? Colors.deepPurple.value,
      isLight: sp.getBool(brightnessKey) ?? true,
      appColorScheme: sp.getInt(appColorSchemeKey) ?? Colors.deepPurple.value,
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
}
