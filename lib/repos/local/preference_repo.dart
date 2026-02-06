import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/animation_modes.dart';
import '../../configs/locale_constants.dart';

class PreferenceRepo {
  PreferenceRepo({required SharedPreferences sharedPreferences})
    : _sp = sharedPreferences;

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
  static const enableAnimationKey = 'enable animation';
  static const toleranceKey = 'tolerance';
  static const animationModeKey = 'animation mode';
  static const transparentNotFoundTxtKey = 'transparent not found';
  static const localeKey = 'locale';

  static const defaultFont = 'Roboto';

  double get opacity => _sp.getDouble(windowOpacityKey) ?? 50;

  int get color => _sp.getInt(windowColorKey) ?? Colors.deepPurple.toARGB32();

  int get backgroundColor =>
      _sp.getInt(windowBackgroundColorKey) ?? Colors.black.toARGB32();

  bool get isLight => _sp.getBool(brightnessKey) ?? true;

  int get appColorScheme =>
      _sp.getInt(appColorSchemeKey) ?? Colors.deepPurple.toARGB32();

  bool get showMilliseconds => _sp.getBool(showMillisecondsKey) ?? false;

  bool get showProgressBar => _sp.getBool(showProgressBarKey) ?? true;

  /// Empty string means default font family of Flutter
  /// Else it will be the font family name from Google Fonts
  String get fontFamily => _sp.getString(fontFamilyKey) ?? defaultFont;

  int get fontSize => _sp.getInt(fontSizeKey) ?? 24;

  bool get autoFetchOnline => _sp.getBool(autoFetchOnlineKey) ?? true;

  bool get showLine2 => _sp.getBool(showLine2Key) ?? true;

  bool get useAppColor => _sp.getBool(useAppColorKey) ?? true;

  bool get enableAnimation => _sp.getBool(enableAnimationKey) ?? true;

  int get tolerance => _sp.getInt(toleranceKey) ?? 0;

  AnimationMode get animationMode {
    final mode = _sp.getString(animationModeKey);
    return mode == null
        ? AnimationMode.fadeIn
        : AnimationMode.values.firstWhereOrNull((e) => e.name == mode) ??
              AnimationMode.fadeIn;
  }

  bool get transparentNotFoundTxt =>
      _sp.getBool(transparentNotFoundTxtKey) ?? false;

  String get locale => _sp.getString(localeKey) ?? LocaleConstants.defaultLocale;

  Future<bool> updateOpacity(double value) =>
      _sp.setDouble(windowOpacityKey, value);

  Future<bool> updateColor(int colorVal) =>
      _sp.setInt(windowColorKey, colorVal);

  Future<bool> updateBackgroundColor(int colorVal) =>
      _sp.setInt(windowBackgroundColorKey, colorVal);

  Future<bool> toggleBrightness(bool isLight) =>
      _sp.setBool(brightnessKey, isLight);

  Future<bool> updateAppColorScheme(int colorValue) =>
      _sp.setInt(appColorSchemeKey, colorValue);

  Future<bool> toggleShowMilliseconds(bool showMillis) =>
      _sp.setBool(showMillisecondsKey, showMillis);

  Future<bool> toggleShowProgressBar(bool showProgressBar) =>
      _sp.setBool(showProgressBarKey, showProgressBar);

  Future<bool> updateFontFamily(String fontFamily) =>
      _sp.setString(fontFamilyKey, fontFamily);

  Future<bool> updateFontSize(int fontSize) =>
      _sp.setInt(fontSizeKey, fontSize);

  Future<bool> toggleAutoFetchOnline(bool value) =>
      _sp.setBool(autoFetchOnlineKey, value);

  Future<bool> toggleShowLine2(bool value) => _sp.setBool(showLine2Key, value);

  Future<bool> toggleUseAppColor(bool value) =>
      _sp.setBool(useAppColorKey, value);

  Future<bool> resetFontFamily() => _sp.setString(fontFamilyKey, defaultFont);

  Future<bool> toggleEnableAnimation(bool value) =>
      _sp.setBool(enableAnimationKey, value);

  Future<bool> updateTolerance(int value) => _sp.setInt(toleranceKey, value);

  Future<bool> updateAnimationMode(AnimationMode mode) =>
      _sp.setString(animationModeKey, mode.name);

  Future<bool> updateTransparentNotFoundTxt(bool transparentNotFoundTxt) =>
      _sp.setBool(transparentNotFoundTxtKey, transparentNotFoundTxt);

  Future<bool> updateLocale(String locale) => _sp.setString(localeKey, locale);
}
