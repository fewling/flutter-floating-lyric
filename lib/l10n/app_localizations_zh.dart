// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get permission_screen_notif_listener_permission_title => '通知監聽權限';

  @override
  String get permission_screen_overlay_window_permission_title => '浮窗權限';

  @override
  String get home => '首頁';

  @override
  String get storedLyrics => '本地歌詞';

  @override
  String get settings => '設定';
}
