// ignore_for_file: avoid_setters_without_getters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preference.freezed.dart';
part 'app_preference.g.dart';

final sharedPreferenceProvider =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

final preferenceProvider =
    NotifierProvider<PreferenceNotifier, PreferenceState>(
        PreferenceNotifier.new);

class PreferenceNotifier extends Notifier<PreferenceState> {
  static const opacityKey = 'opacity';
  static const colorKey = 'color';
  static const backgroundColorKey = 'backgroundColor';
  static const brightnessKey = 'brightness';

  @override
  PreferenceState build() {
    return PreferenceState(
      opacity: ref.watch(sharedPreferenceProvider).getDouble(opacityKey) ?? 50,
      color: ref.watch(sharedPreferenceProvider).getInt(colorKey) ??
          Colors.deepPurple.value,
      isLight:
          ref.watch(sharedPreferenceProvider).getBool(brightnessKey) ?? true,
    );
  }

  void updateOpacity(double value) => ref
      .read(sharedPreferenceProvider)
      .setDouble(opacityKey, value)
      .then((result) => state = state.copyWith(opacity: value));

  void updateColor(Color color) => ref
      .read(sharedPreferenceProvider)
      .setInt(colorKey, color.value)
      .then((value) => state = state.copyWith(color: color.value));

  void toggleBrightness() => ref
      .read(sharedPreferenceProvider)
      .setBool(brightnessKey, !state.isLight)
      .then((value) => state = state.copyWith(isLight: !state.isLight));
}

@freezed
class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    required double opacity,
    required int color,
    required bool isLight,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) =>
      _$PreferenceStateFromJson(json);
}
