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

  @override
  PreferenceState build() {
    return PreferenceState(
      opacity: ref.watch(sharedPreferenceProvider).getDouble(opacityKey) ?? 50,
      color: ref.watch(sharedPreferenceProvider).getInt(colorKey) ??
          Colors.deepPurple.value,
      backgroundColor:
          ref.watch(sharedPreferenceProvider).getInt(backgroundColorKey) ??
              Colors.black.value,
    );
  }

  void updateOpacity(double value) => ref
      .read(sharedPreferenceProvider)
      .setDouble(opacityKey, value)
      .then((result) => state = state.copyWith(opacity: value));

  void updateColor(int value) => ref
      .read(sharedPreferenceProvider)
      .setInt(colorKey, value)
      .then((result) => state = state.copyWith(color: value));

  void updateBackgroundColor(int value) => ref
      .read(sharedPreferenceProvider)
      .setInt(backgroundColorKey, value)
      .then((result) => state = state.copyWith(backgroundColor: value));
}

@freezed
class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    required double opacity,
    required int color,
    required int backgroundColor,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) =>
      _$PreferenceStateFromJson(json);
}
