import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/preferences/app_preference_notifier.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  void build() {}

  void setAppColorScheme(int colorValue) => ref
      .read(preferenceNotifierProvider.notifier)
      .updateAppColorScheme(colorValue);

  void toggleBrightness() =>
      ref.read(preferenceNotifierProvider.notifier).toggleBrightness();
}
