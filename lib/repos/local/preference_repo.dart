import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepo {
  PreferenceRepo({
    required SharedPreferences sharedPreferences,
  }) : _sp = sharedPreferences;

  final SharedPreferences _sp;

  static const windowOpacityKey = 'window opacity';
  static const windowColorKey = 'window color';
  static const windowBackgroundColorKey = 'window background color';
  static const brightnessKey = 'brightness';
  static const appColorSchemeKey = 'app color scheme';
  static const showMillisecondsKey = 'show milliseconds';
  static const showProgressBarKey = 'show progress bar';
  static const fontFamilyKey = 'font family';
  static const fontSizeKey = 'font size';
  static const autoFetchOnlineKey = 'auto fetch online';
  static const showLine2Key = 'show line 2';
  static const useAppColorKey = 'use app color';

  double get opacity => _sp.getDouble(windowOpacityKey) ?? 50;

  int get color => _sp.getInt(windowColorKey) ?? Colors.deepPurple.value;

  int get backgroundColor => _sp.getInt(windowBackgroundColorKey) ?? Colors.black.value;

  bool get isLight => _sp.getBool(brightnessKey) ?? true;

  int get appColorScheme => _sp.getInt(appColorSchemeKey) ?? Colors.deepPurple.value;

  bool get showMilliseconds => _sp.getBool(showMillisecondsKey) ?? false;

  bool get showProgressBar => _sp.getBool(showProgressBarKey) ?? true;

  /// Empty string means default font family of Flutter
  /// Else it will be the font family name from Google Fonts
  String get fontFamily => _sp.getString(fontFamilyKey) ?? '';

  int get fontSize => _sp.getInt(fontSizeKey) ?? 24;

  bool get autoFetchOnline => _sp.getBool(autoFetchOnlineKey) ?? true;

  bool get showLine2 => _sp.getBool(showLine2Key) ?? true;

  bool get useAppColor => _sp.getBool(useAppColorKey) ?? true;

  Future<bool> updateOpacity(double value) => _sp.setDouble(windowOpacityKey, value);

  Future<bool> updateColor(int colorVal) => _sp.setInt(windowColorKey, colorVal);

  Future<bool> updateBackgroundColor(int colorVal) => _sp.setInt(windowBackgroundColorKey, colorVal);

  Future<bool> toggleBrightness(bool isLight) => _sp.setBool(brightnessKey, isLight);

  Future<bool> updateAppColorScheme(int colorValue) => _sp.setInt(appColorSchemeKey, colorValue);

  Future<bool> toggleShowMilliseconds(bool showMillis) => _sp.setBool(showMillisecondsKey, showMillis);

  Future<bool> toggleShowProgressBar(bool showProgressBar) => _sp.setBool(showProgressBarKey, showProgressBar);

  Future<bool> updateFontFamily(String fontFamily) => _sp.setString(fontFamilyKey, fontFamily);

  Future<bool> updateFontSize(int fontSize) => _sp.setInt(fontSizeKey, fontSize);

  Future<bool> toggleAutoFetchOnline(bool value) => _sp.setBool(autoFetchOnlineKey, value);

  Future<bool> toggleShowLine2(bool value) => _sp.setBool(showLine2Key, value);

  Future<bool> toggleUseAppColor(bool value) => _sp.setBool(useAppColorKey, value);
}
