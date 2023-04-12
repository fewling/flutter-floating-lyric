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
  PreferenceState build() => const PreferenceState();

  double get opacity =>
      ref.read(sharedPreferenceProvider).getDouble(opacityKey) ?? 50;

  int get color =>
      ref.read(sharedPreferenceProvider).getInt(colorKey) ??
      Colors.deepPurple.value;

  int get backgroundColor =>
      ref.read(sharedPreferenceProvider).getInt(backgroundColorKey) ??
      Colors.black.value;

  set opacity(double value) => ref
      .read(sharedPreferenceProvider)
      .setDouble(opacityKey, value)
      .then((_) => state = state.copyWith(opacity: value));

  set color(int value) => ref
      .read(sharedPreferenceProvider)
      .setInt(colorKey, value)
      .then((_) => state = state.copyWith(color: value));

  set backgroundColor(int value) => ref
      .read(sharedPreferenceProvider)
      .setInt(backgroundColorKey, value)
      .then((_) => state = state.copyWith(color: value));
}

@freezed
class PreferenceState with _$PreferenceState {
  const factory PreferenceState({
    @Default(50) double opacity,
    @Default(0xFF673AB7) int color,
    @Default(0xFF000000) int backgroundColor,
  }) = _PreferenceState;

  factory PreferenceState.fromJson(Map<String, dynamic> json) =>
      _$PreferenceStateFromJson(json);
}
