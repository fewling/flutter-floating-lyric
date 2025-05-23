import 'dart:ui';

import '../../configs/animation_modes.dart';
import '../../repos/local/preference_repo.dart';

class PreferenceService {
  PreferenceService({required PreferenceRepo spRepo}) : _spRepo = spRepo;

  final PreferenceRepo _spRepo;

  double get opacity => _spRepo.opacity;

  int get color => _spRepo.color;

  int get backgroundColor => _spRepo.backgroundColor;

  bool get isLight => _spRepo.isLight;

  int get appColorScheme => _spRepo.appColorScheme;

  bool get showMilliseconds => _spRepo.showMilliseconds;

  bool get showProgressBar => _spRepo.showProgressBar;

  String get fontFamily => _spRepo.fontFamily;

  int get fontSize => _spRepo.fontSize;

  bool get autoFetchOnline => _spRepo.autoFetchOnline;

  bool get showLine2 => _spRepo.showLine2;

  bool get useAppColor => _spRepo.useAppColor;

  bool get enableAnimation => _spRepo.enableAnimation;

  int get tolerance => _spRepo.tolerance;

  AnimationMode get animationMode => _spRepo.animationMode;

  Future<bool> updateOpacity(double value) => _spRepo.updateOpacity(value);

  Future<bool> updateColor(Color color) =>
      _spRepo.updateColor(color.toARGB32());

  Future<bool> updateBackgroundColor(Color color) =>
      _spRepo.updateBackgroundColor(color.toARGB32());

  Future<bool> toggleBrightness(bool isLight) =>
      _spRepo.toggleBrightness(isLight);

  Future<bool> updateAppColorScheme(int colorValue) =>
      _spRepo.updateAppColorScheme(colorValue);

  Future<bool> toggleShowMilliseconds(bool showMillis) =>
      _spRepo.toggleShowMilliseconds(showMillis);

  Future<bool> toggleShowProgressBar(bool showProgressBar) =>
      _spRepo.toggleShowProgressBar(showProgressBar);

  Future<bool> updateFontFamily(String fontFamily) =>
      _spRepo.updateFontFamily(fontFamily);

  Future<bool> updateFontSize(int fontSize) => _spRepo.updateFontSize(fontSize);

  Future<bool> toggleAutoFetchOnline(bool value) =>
      _spRepo.toggleAutoFetchOnline(value);

  Future<bool> toggleShowLine2(bool value) => _spRepo.toggleShowLine2(value);

  Future<bool> toggleUseAppColor(bool value) =>
      _spRepo.toggleUseAppColor(value);

  Future<bool> resetFontFamily() => _spRepo.resetFontFamily();

  Future<bool> toggleEnableAnimation(bool value) =>
      _spRepo.toggleEnableAnimation(value);

  Future<bool> updateTolerance(int value) => _spRepo.updateTolerance(value);

  Future<bool> updateAnimationMode(AnimationMode mode) =>
      _spRepo.updateAnimationMode(mode);
}
