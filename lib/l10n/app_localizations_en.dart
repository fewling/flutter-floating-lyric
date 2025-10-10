// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get permission_screen_notif_listener_permission_title =>
      'Notification Listener Permission';

  @override
  String get permission_screen_overlay_window_permission_title =>
      'Overlay Window Permission';

  @override
  String get home => 'Home';

  @override
  String get storedLyrics => 'Stored Lyrics';

  @override
  String get settings => 'Settings';
}
