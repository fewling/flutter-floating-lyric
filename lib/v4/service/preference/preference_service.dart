import 'dart:ui';

import '../../repos/local/preference_repo.dart';

class PreferenceService {
  PreferenceService({
    required PreferenceRepo spRepo,
  }) : _spRepo = spRepo;

  final PreferenceRepo _spRepo;

  double get opacity => _spRepo.opacity;

  int get color => _spRepo.color;

  bool get isLight => _spRepo.isLight;

  int get appColorScheme => _spRepo.appColorScheme;

  bool get showMilliseconds => _spRepo.showMilliseconds;

  bool get showProgressBar => _spRepo.showProgressBar;

  int get fontSize => _spRepo.fontSize;

  bool get autoFetchOnline => _spRepo.autoFetchOnline;

  Future<bool> updateOpacity(double value) => _spRepo.updateOpacity(value);

  Future<bool> updateColor(Color color) => _spRepo.updateColor(color.value);

  Future<bool> toggleBrightness(bool isLight) => _spRepo.toggleBrightness(isLight);

  Future<bool> updateAppColorScheme(int colorValue) => _spRepo.updateAppColorScheme(colorValue);

  Future<bool> toggleShowMilliseconds(bool showMillis) => _spRepo.toggleShowMilliseconds(showMillis);

  Future<bool> toggleShowProgressBar(bool showProgressBar) => _spRepo.toggleShowProgressBar(showProgressBar);

  Future<bool> updateFontSize(int fontSize) => _spRepo.updateFontSize(fontSize);

  Future<bool> toggleAutoFetchOnline(bool value) => _spRepo.toggleAutoFetchOnline(value);
}