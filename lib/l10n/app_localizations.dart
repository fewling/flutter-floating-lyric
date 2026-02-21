import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @permission_screen_notif_listener_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Notification Listener Permission'**
  String get permission_screen_notif_listener_permission_title;

  /// No description provided for @permission_screen_notif_listener_permission_instruction.
  ///
  /// In en, this message translates to:
  /// **'This app needs to access the music player in the notification bar to work.'**
  String get permission_screen_notif_listener_permission_instruction;

  /// No description provided for @permission_screen_notif_listener_permission_step1.
  ///
  /// In en, this message translates to:
  /// **'1. Grant Access button'**
  String get permission_screen_notif_listener_permission_step1;

  /// No description provided for @permission_screen_notif_listener_permission_step2.
  ///
  /// In en, this message translates to:
  /// **'2. This app'**
  String get permission_screen_notif_listener_permission_step2;

  /// No description provided for @permission_screen_notif_listener_permission_step3.
  ///
  /// In en, this message translates to:
  /// **'3. Turn on \"Allow notification access\"'**
  String get permission_screen_notif_listener_permission_step3;

  /// No description provided for @permission_screen_overlay_window_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Overlay Window Permission'**
  String get permission_screen_overlay_window_permission_title;

  /// No description provided for @permission_screen_overlay_window_permission_instruction.
  ///
  /// In en, this message translates to:
  /// **'This permission is required to display floating window on top of other apps.'**
  String get permission_screen_overlay_window_permission_instruction;

  /// No description provided for @permission_screen_overlay_window_permission_step1.
  ///
  /// In en, this message translates to:
  /// **'1. Grant Access button'**
  String get permission_screen_overlay_window_permission_step1;

  /// No description provided for @permission_screen_overlay_window_permission_step2.
  ///
  /// In en, this message translates to:
  /// **'2. This app'**
  String get permission_screen_overlay_window_permission_step2;

  /// No description provided for @permission_screen_overlay_window_permission_step3.
  ///
  /// In en, this message translates to:
  /// **'3. Turn on \"Allow display over other apps\"'**
  String get permission_screen_overlay_window_permission_step3;

  /// No description provided for @permission_screen_grant_access.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get permission_screen_grant_access;

  /// No description provided for @permission_screen_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get permission_screen_done;

  /// No description provided for @permission_screen_missing_permission.
  ///
  /// In en, this message translates to:
  /// **'Missing Permission'**
  String get permission_screen_missing_permission;

  /// No description provided for @permission_screen_enable_permissions.
  ///
  /// In en, this message translates to:
  /// **'Please enable the permissions to proceed.'**
  String get permission_screen_enable_permissions;

  /// No description provided for @permission_screen_notification_access.
  ///
  /// In en, this message translates to:
  /// **'Notification Access'**
  String get permission_screen_notification_access;

  /// No description provided for @permission_screen_display_window_over_apps.
  ///
  /// In en, this message translates to:
  /// **'Display Window Over Apps'**
  String get permission_screen_display_window_over_apps;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get language_chinese;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @storedLyrics.
  ///
  /// In en, this message translates to:
  /// **'Stored Lyrics'**
  String get storedLyrics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home_screen_window_configs.
  ///
  /// In en, this message translates to:
  /// **'Window Configs'**
  String get home_screen_window_configs;

  /// No description provided for @home_screen_import_lyrics.
  ///
  /// In en, this message translates to:
  /// **'Import Lyrics'**
  String get home_screen_import_lyrics;

  /// No description provided for @home_screen_online_lyrics.
  ///
  /// In en, this message translates to:
  /// **'Online Lyrics'**
  String get home_screen_online_lyrics;

  /// No description provided for @lyric_list_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get lyric_list_import;

  /// No description provided for @lyric_list_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lyric_list_delete;

  /// No description provided for @lyric_list_delete_all.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get lyric_list_delete_all;

  /// No description provided for @lyric_list_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get lyric_list_cancel;

  /// No description provided for @lyric_list_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get lyric_list_refresh;

  /// No description provided for @lyric_list_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get lyric_list_search;

  /// No description provided for @lyric_list_filename.
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get lyric_list_filename;

  /// No description provided for @lyric_list_no_lyrics_found.
  ///
  /// In en, this message translates to:
  /// **'No lyrics found.'**
  String get lyric_list_no_lyrics_found;

  /// No description provided for @lyric_list_delete_all_title.
  ///
  /// In en, this message translates to:
  /// **'Delete All Lyric'**
  String get lyric_list_delete_all_title;

  /// No description provided for @lyric_list_delete_all_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete All lyrics?'**
  String get lyric_list_delete_all_message;

  /// No description provided for @lyric_list_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Lyric'**
  String get lyric_list_delete_title;

  /// No description provided for @lyric_list_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this lyric?'**
  String get lyric_list_delete_message;

  /// No description provided for @lyric_list_error_deleting_lyrics.
  ///
  /// In en, this message translates to:
  /// **'Error deleting lyrics.'**
  String get lyric_list_error_deleting_lyrics;

  /// No description provided for @lyric_list_error_deleting_lyric.
  ///
  /// In en, this message translates to:
  /// **'Error deleting lyric.'**
  String get lyric_list_error_deleting_lyric;

  /// No description provided for @lyric_detail_error_saving_lyric.
  ///
  /// In en, this message translates to:
  /// **'Error saving lyric'**
  String get lyric_detail_error_saving_lyric;

  /// No description provided for @lyric_detail_lyric_saved.
  ///
  /// In en, this message translates to:
  /// **'Lyric saved'**
  String get lyric_detail_lyric_saved;

  /// No description provided for @settings_use_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Use Dark Mode'**
  String get settings_use_dark_mode;

  /// No description provided for @settings_color_scheme.
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get settings_color_scheme;

  /// No description provided for @settings_bug_report_feature_request.
  ///
  /// In en, this message translates to:
  /// **'Bug Report/Feature Request'**
  String get settings_bug_report_feature_request;

  /// No description provided for @settings_send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get settings_send_feedback;

  /// No description provided for @settings_known_issues.
  ///
  /// In en, this message translates to:
  /// **'Known Issues'**
  String get settings_known_issues;

  /// No description provided for @settings_known_issues_issue1.
  ///
  /// In en, this message translates to:
  /// **'In some heavy customized Android OS like MIUI, ColorOS, HuaWei: '**
  String get settings_known_issues_issue1;

  /// No description provided for @settings_known_issues_issue2.
  ///
  /// In en, this message translates to:
  /// **'1. Could not retrieve necessary permissions.'**
  String get settings_known_issues_issue2;

  /// No description provided for @settings_known_issues_issue3.
  ///
  /// In en, this message translates to:
  /// **'2. Not detecting music app from notification bar.'**
  String get settings_known_issues_issue3;

  /// No description provided for @overlay_window_hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get overlay_window_hide;

  /// No description provided for @overlay_window_show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get overlay_window_show;

  /// No description provided for @overlay_window_styling.
  ///
  /// In en, this message translates to:
  /// **'Styling'**
  String get overlay_window_styling;

  /// No description provided for @overlay_window_use_app_color.
  ///
  /// In en, this message translates to:
  /// **'Use App Color'**
  String get overlay_window_use_app_color;

  /// No description provided for @overlay_window_custom_background_color.
  ///
  /// In en, this message translates to:
  /// **'Custom Backgound Color'**
  String get overlay_window_custom_background_color;

  /// No description provided for @overlay_window_pick_a_color.
  ///
  /// In en, this message translates to:
  /// **'Pick a color!'**
  String get overlay_window_pick_a_color;

  /// No description provided for @overlay_window_got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get overlay_window_got_it;

  /// No description provided for @overlay_window_opacity.
  ///
  /// In en, this message translates to:
  /// **'Window Opacity'**
  String get overlay_window_opacity;

  /// No description provided for @overlay_window_font_family.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get overlay_window_font_family;

  /// No description provided for @overlay_window_lyrics_font_size.
  ///
  /// In en, this message translates to:
  /// **'Lyrics Font Size'**
  String get overlay_window_lyrics_font_size;

  /// No description provided for @overlay_window_custom_text_color.
  ///
  /// In en, this message translates to:
  /// **'Custom Text Color'**
  String get overlay_window_custom_text_color;

  /// No description provided for @overlay_window_element_visibilities.
  ///
  /// In en, this message translates to:
  /// **'Element Visibilities'**
  String get overlay_window_element_visibilities;

  /// No description provided for @overlay_window_show_milliseconds.
  ///
  /// In en, this message translates to:
  /// **'Show Milliseconds'**
  String get overlay_window_show_milliseconds;

  /// No description provided for @overlay_window_hide_milliseconds.
  ///
  /// In en, this message translates to:
  /// **'Hide Milliseconds'**
  String get overlay_window_hide_milliseconds;

  /// No description provided for @overlay_window_show_progress_bar.
  ///
  /// In en, this message translates to:
  /// **'Show Progress Bar'**
  String get overlay_window_show_progress_bar;

  /// No description provided for @overlay_window_hide_progress_bar.
  ///
  /// In en, this message translates to:
  /// **'Hide Progress Bar'**
  String get overlay_window_hide_progress_bar;

  /// No description provided for @overlay_window_hide_no_lyrics_found_text.
  ///
  /// In en, this message translates to:
  /// **'Hide \"No Lyrics Found\" Text'**
  String get overlay_window_hide_no_lyrics_found_text;

  /// No description provided for @overlay_window_show_no_lyrics_found_text.
  ///
  /// In en, this message translates to:
  /// **'Show \"No Lyrics Found\" Text'**
  String get overlay_window_show_no_lyrics_found_text;

  /// No description provided for @overlay_window_no_lyrics_found_subtitle.
  ///
  /// In en, this message translates to:
  /// **'When no lyrics is found, toggle the text transparency.'**
  String get overlay_window_no_lyrics_found_subtitle;

  /// No description provided for @overlay_window_visible_lines_count.
  ///
  /// In en, this message translates to:
  /// **'No. of Visible Lines'**
  String get overlay_window_visible_lines_count;

  /// No description provided for @overlay_window_enable_animation.
  ///
  /// In en, this message translates to:
  /// **'Enable Animation'**
  String get overlay_window_enable_animation;

  /// No description provided for @overlay_window_disable_animation.
  ///
  /// In en, this message translates to:
  /// **'Disable Animation'**
  String get overlay_window_disable_animation;

  /// No description provided for @overlay_window_tolerance.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get overlay_window_tolerance;

  /// No description provided for @overlay_window_tolerance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase this to make the lyrics ahead of the song, vice versa.'**
  String get overlay_window_tolerance_subtitle;

  /// No description provided for @overlay_window_special_settings.
  ///
  /// In en, this message translates to:
  /// **'Special Settings'**
  String get overlay_window_special_settings;

  /// No description provided for @overlay_window_ignore_touch.
  ///
  /// In en, this message translates to:
  /// **'Ignore Touch'**
  String get overlay_window_ignore_touch;

  /// No description provided for @overlay_window_ignore_touch_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enabling this will lock the window from moving too.\\nDisabling this will not unlock it.'**
  String get overlay_window_ignore_touch_subtitle;

  /// No description provided for @overlay_window_touch_through.
  ///
  /// In en, this message translates to:
  /// **'Touch Through'**
  String get overlay_window_touch_through;

  /// No description provided for @overlay_window_touch_through_subtitle.
  ///
  /// In en, this message translates to:
  /// **'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\\nSuch issue is due to Android\'s design limitation and is out of this app\'s control. 🙏'**
  String get overlay_window_touch_through_subtitle;

  /// No description provided for @fetch_online_auto_fetch.
  ///
  /// In en, this message translates to:
  /// **'Auto Fetch'**
  String get fetch_online_auto_fetch;

  /// No description provided for @fetch_online_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fetch_online_title;

  /// No description provided for @fetch_online_artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get fetch_online_artist;

  /// No description provided for @fetch_online_album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get fetch_online_album;

  /// No description provided for @fetch_online_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get fetch_online_duration;

  /// No description provided for @common_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get common_unknown;

  /// No description provided for @fetch_online_powered_by.
  ///
  /// In en, this message translates to:
  /// **'Powered by '**
  String get fetch_online_powered_by;

  /// No description provided for @fetch_online_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get fetch_online_search;

  /// No description provided for @fetch_online_lyric_fetch_result.
  ///
  /// In en, this message translates to:
  /// **'Lyric Fetch Result'**
  String get fetch_online_lyric_fetch_result;

  /// No description provided for @fetch_online_no_lyric_found.
  ///
  /// In en, this message translates to:
  /// **'No lyric found for this song.'**
  String get fetch_online_no_lyric_found;

  /// No description provided for @fetch_online_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get fetch_online_close;

  /// No description provided for @fetch_online_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get fetch_online_save;

  /// No description provided for @fetch_online_lyric_saved.
  ///
  /// In en, this message translates to:
  /// **'Lyric saved'**
  String get fetch_online_lyric_saved;

  /// No description provided for @fetch_online_failed_to_save_lyric.
  ///
  /// In en, this message translates to:
  /// **'Failed to save lyric'**
  String get fetch_online_failed_to_save_lyric;

  /// No description provided for @fetch_online_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Title of the song'**
  String get fetch_online_title_hint;

  /// No description provided for @fetch_online_artist_hint.
  ///
  /// In en, this message translates to:
  /// **'Artist of the song'**
  String get fetch_online_artist_hint;

  /// No description provided for @fetch_online_album_hint.
  ///
  /// In en, this message translates to:
  /// **'Album of the song'**
  String get fetch_online_album_hint;

  /// No description provided for @import_local_lrc_your_lrc_file_format.
  ///
  /// In en, this message translates to:
  /// **'Your LRC file should match one of the following formats:'**
  String get import_local_lrc_your_lrc_file_format;

  /// No description provided for @import_local_lrc_file_name_format_1.
  ///
  /// In en, this message translates to:
  /// **'1. File name should be:'**
  String get import_local_lrc_file_name_format_1;

  /// No description provided for @import_local_lrc_file_name_format_2.
  ///
  /// In en, this message translates to:
  /// **'2. File name should be:'**
  String get import_local_lrc_file_name_format_2;

  /// No description provided for @import_local_lrc_file_should_contain.
  ///
  /// In en, this message translates to:
  /// **'3. File should contain:'**
  String get import_local_lrc_file_should_contain;

  /// No description provided for @import_local_lrc_importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get import_local_lrc_importing;

  /// No description provided for @import_local_lrc_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import_local_lrc_import;

  /// No description provided for @fail_import_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Failed to Import Files:'**
  String get fail_import_dialog_title;

  /// No description provided for @fail_import_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Please make sure the file is a valid .lrc file.'**
  String get fail_import_dialog_message;

  /// No description provided for @fail_import_dialog_learn_more.
  ///
  /// In en, this message translates to:
  /// **'Tap here to learn supported file formats.'**
  String get fail_import_dialog_learn_more;

  /// No description provided for @font_select_font_options.
  ///
  /// In en, this message translates to:
  /// **'Font Options'**
  String get font_select_font_options;

  /// No description provided for @font_select_reset_font_family.
  ///
  /// In en, this message translates to:
  /// **'Reset font family'**
  String get font_select_reset_font_family;

  /// No description provided for @font_select_search_font.
  ///
  /// In en, this message translates to:
  /// **'Search font'**
  String get font_select_search_font;

  /// No description provided for @font_select_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'To save your internet data, limited options are loaded each time.\\nWe recommend visiting Google Fonts to view and feel the full list of fonts.\\nThen, you can search for the font name here and apply it.'**
  String get font_select_disclaimer;

  /// No description provided for @font_select_visit_google_fonts.
  ///
  /// In en, this message translates to:
  /// **'Visit Google Fonts'**
  String get font_select_visit_google_fonts;

  /// No description provided for @font_select_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get font_select_unknown;

  /// No description provided for @error_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_dialog_title;

  /// No description provided for @error_dialog_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get error_dialog_ok;

  /// No description provided for @error_dialog_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get error_dialog_report;

  /// No description provided for @overlay_window_no_lyric.
  ///
  /// In en, this message translates to:
  /// **'No lyric'**
  String get overlay_window_no_lyric;

  /// No description provided for @overlay_window_searching_lyric.
  ///
  /// In en, this message translates to:
  /// **'Searching lyric...'**
  String get overlay_window_searching_lyric;

  /// No description provided for @overlay_window_waiting_for_music_player.
  ///
  /// In en, this message translates to:
  /// **'Waiting for music player'**
  String get overlay_window_waiting_for_music_player;

  /// No description provided for @media_state_play_song.
  ///
  /// In en, this message translates to:
  /// **'Play a song'**
  String get media_state_play_song;

  /// No description provided for @media_state_not_detecting_title.
  ///
  /// In en, this message translates to:
  /// **'Not detecting active music player?'**
  String get media_state_not_detecting_title;

  /// No description provided for @media_state_not_detecting_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap here to re-enable the notification listener'**
  String get media_state_not_detecting_subtitle;

  /// No description provided for @media_state_learn_more.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get media_state_learn_more;

  /// No description provided for @media_state_notification_listener_title.
  ///
  /// In en, this message translates to:
  /// **'Notification Listener'**
  String get media_state_notification_listener_title;

  /// No description provided for @media_state_notification_listener_info1.
  ///
  /// In en, this message translates to:
  /// **'On some Android devices (such as those from Huawei or Xiaomi), system-level battery and memory management features may restrict background services, including the notification listener required for music detection.'**
  String get media_state_notification_listener_info1;

  /// No description provided for @media_state_notification_listener_info2.
  ///
  /// In en, this message translates to:
  /// **'If the app is closed, these optimizations can terminate the background service after a short period, and it may not restart automatically.'**
  String get media_state_notification_listener_info2;

  /// No description provided for @media_state_notification_listener_info3.
  ///
  /// In en, this message translates to:
  /// **'If music is not being detected, please tap the button above to manually re-enable the notification listener.'**
  String get media_state_notification_listener_info3;

  /// No description provided for @media_state_notification_listener_info4.
  ///
  /// In en, this message translates to:
  /// **'Due to manufacturer-specific customizations and limited documentation, ensuring reliable background operation on these devices can be challenging. We appreciate your understanding as we continue to improve compatibility.'**
  String get media_state_notification_listener_info4;

  /// No description provided for @overlay_window_element_visibilities_title.
  ///
  /// In en, this message translates to:
  /// **'Element Visibilities'**
  String get overlay_window_element_visibilities_title;

  /// No description provided for @overlay_window_special_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Special Settings'**
  String get overlay_window_special_settings_title;

  /// No description provided for @overlay_window_tolerance_title.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get overlay_window_tolerance_title;

  /// No description provided for @overlay_window_ignore_touch_title.
  ///
  /// In en, this message translates to:
  /// **'Ignore Touch'**
  String get overlay_window_ignore_touch_title;

  /// No description provided for @overlay_window_touch_through_title.
  ///
  /// In en, this message translates to:
  /// **'Touch Through'**
  String get overlay_window_touch_through_title;

  /// No description provided for @overlay_window_touch_through_subtitle_line1.
  ///
  /// In en, this message translates to:
  /// **'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.'**
  String get overlay_window_touch_through_subtitle_line1;

  /// No description provided for @overlay_window_touch_through_subtitle_line2.
  ///
  /// In en, this message translates to:
  /// **'Such issue is due to Android\'s design limitation and is out of this app\'s control. 🙏'**
  String get overlay_window_touch_through_subtitle_line2;

  /// No description provided for @animation_mode_fade_in.
  ///
  /// In en, this message translates to:
  /// **'Fade In'**
  String get animation_mode_fade_in;

  /// No description provided for @animation_mode_typer.
  ///
  /// In en, this message translates to:
  /// **'Typer'**
  String get animation_mode_typer;

  /// No description provided for @animation_mode_type_writer.
  ///
  /// In en, this message translates to:
  /// **'Type Writer'**
  String get animation_mode_type_writer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
