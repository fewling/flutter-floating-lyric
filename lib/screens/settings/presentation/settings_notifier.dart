import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void launchFeedbackEmail() {
    final uri = Uri(
      scheme: 'mailto',
      path: 'floatinglyricsapp@gmail.com',
      query: encodeQueryParameters({'subject': 'Feedback'}),
    );
    launchUrl(uri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
