import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  void _onFeedbackEmailClicked(FeedbackEmailClicked event, Emitter<SettingsState> emit) {
    final uri = Uri(
      scheme: 'mailto',
      path: 'floatinglyricsapp@gmail.com',

      // TODO(@fewling): Include the followings:
      // - version number
      // - build number
      // - device model
      // - OS version
      // Take reference to Flutter's issue template.
      query: _encodeQueryParameters({'subject': 'Feedback'}),
    );
    launchUrl(uri);
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
