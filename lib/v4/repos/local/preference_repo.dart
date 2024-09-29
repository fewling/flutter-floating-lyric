import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepo {
  PreferenceRepo({
    required SharedPreferences sharedPreferences,
  }) : _sp = sharedPreferences;

  final SharedPreferences _sp;

  static const windowOpacityKey = 'window opacity';
  static const windowColorKey = 'window color';
  static const brightnessKey = 'brightness';
  static const appColorSchemeKey = 'app color scheme';
  static const showMillisecondsKey = 'show milliseconds';
  static const showProgressBarKey = 'show progress bar';
  static const fontSizeKey = 'font size';
  static const autoFetchOnlineKey = 'auto fetch online';

  double get opacity => _sp.getDouble(windowOpacityKey) ?? 50;

  int get color => _sp.getInt(windowColorKey) ?? Colors.deepPurple.value;

  bool get isLight => _sp.getBool(brightnessKey) ?? true;

  int get appColorScheme => _sp.getInt(appColorSchemeKey) ?? Colors.deepPurple.value;

  bool get showMilliseconds => _sp.getBool(showMillisecondsKey) ?? true;

  bool get showProgressBar => _sp.getBool(showProgressBarKey) ?? true;

  int get fontSize => _sp.getInt(fontSizeKey) ?? 24;

  bool get autoFetchOnline => _sp.getBool(autoFetchOnlineKey) ?? false;

  Future<bool> updateOpacity(double value) => _sp.setDouble(windowOpacityKey, value);

  Future<bool> updateColor(int colorVal) => _sp.setInt(windowColorKey, colorVal);

  Future<bool> toggleBrightness(bool isLight) => _sp.setBool(brightnessKey, isLight);

  Future<bool> updateAppColorScheme(int colorValue) => _sp.setInt(appColorSchemeKey, colorValue);

  Future<bool> toggleShowMilliseconds(bool showMillis) => _sp.setBool(showMillisecondsKey, showMillis);

  Future<bool> toggleShowProgressBar(bool showProgressBar) => _sp.setBool(showProgressBarKey, showProgressBar);

  Future<bool> updateFontSize(int fontSize) => _sp.setInt(fontSizeKey, fontSize);

  Future<bool> toggleAutoFetchOnline(bool value) => _sp.setBool(autoFetchOnlineKey, value);
}
