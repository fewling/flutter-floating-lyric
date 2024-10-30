import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsEvent>(
      (event, emit) => switch (event) {
        FeedbackEmailClicked() => _onFeedbackEmailClicked(event, emit),
      },
    );
  }

  Future<void> _onFeedbackEmailClicked(FeedbackEmailClicked event, Emitter<SettingsState> emit) async {
    final packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;

    final body = '''
# FeedBack/Feature Request:
Please provide information about the feedback or feature request you would like to share here... (if any)

# Bug Report
Please ignore this section, if you are not reporting bugs.
      
## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should have happened?

## Actual Behavior
What happened instead?

## Environment
The following information will help us to diagnose the issue, feel free to remove any information you don't want to share:

App Version: $version ($buildNumber)
Manufacturer: ${androidInfo.manufacturer}
Brand: ${androidInfo.brand}
Device: ${androidInfo.device}
Model: ${androidInfo.model}
Product: ${androidInfo.product}
Version: ${androidInfo.version.sdkInt}
Hardware: ${androidInfo.hardware}
Display: ${androidInfo.display}
Is Low Ram Device: ${androidInfo.isLowRamDevice}
Is Physical Device: ${androidInfo.isPhysicalDevice}
Tags: ${androidInfo.tags}
''';

    final uri = Uri(
      scheme: 'mailto',
      path: 'floatinglyricsapp@gmail.com',

      // TODO(@fewling): Include the followings:
      query: _encodeQueryParameters({
        'subject': 'Feedback',
        'body': body,
      }),
    );
    launchUrl(uri);
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
