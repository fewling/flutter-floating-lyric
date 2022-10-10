import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpansionPanelController extends GetxController {
  static const spWindowPanelKey = 'window panel expanded';
  static const spFilePanelKey = 'file panel expanded';
  static const spColorPanelKey = 'color panel expanded';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _isWindowPanelExpanded.value = _prefs!.getBool(spWindowPanelKey) ?? true;
    _isFilePanelExpanded.value = _prefs!.getBool(spFilePanelKey) ?? true;
    _isColorPanelExpanded.value = _prefs!.getBool(spColorPanelKey) ?? false;
  }

  SharedPreferences? _prefs;

  final _isWindowPanelExpanded = true.obs;
  final _isFilePanelExpanded = true.obs;
  final _isColorPanelExpanded = false.obs;

  bool get isWindowPanelExpanded => _isWindowPanelExpanded.value;
  bool get isFilePanelExpanded => _isFilePanelExpanded.value;
  bool get isColorPanelExpanded => _isColorPanelExpanded.value;

  set isWindowPanelExpanded(bool expanded) {
    _isWindowPanelExpanded.value = expanded;
    _prefs?.setBool(spWindowPanelKey, expanded);
  }

  set isFilePanelExpanded(bool expanded) {
    try {
      _isFilePanelExpanded.value = expanded;
      _prefs?.setBool(spWindowPanelKey, expanded);
    } catch (e) {
      log(e.toString());
    }
  }

  set isColorPanelExpanded(bool expanded) {
    _isColorPanelExpanded.value = expanded;
    _prefs?.setBool(spWindowPanelKey, expanded);
  }
}
