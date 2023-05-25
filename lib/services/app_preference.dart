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
    );
  }

  void updateOpacity(double value) => ref
      .read(sharedPreferenceProvider)
      .setDouble(opacityKey, value)
      .then((result) => state = state.copyWith(opacity: value));

  Future<void> updateColor(Color color) async {
    ref.read(sharedPreferenceProvider).setInt(colorKey, color.value);
    state = state.copyWith(color: color.value);
  }
}

@freezed
class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    required double opacity,
    required int color,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) =>
      _$PreferenceStateFromJson(json);
}
