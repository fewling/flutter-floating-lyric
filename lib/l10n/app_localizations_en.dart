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
  String get permission_screen_notif_listener_permission_instruction =>
      'This app needs to access the music player in the notification bar to work.';

  @override
  String get permission_screen_notif_listener_permission_step1 =>
      '1. Grant Access button';

  @override
  String get permission_screen_notif_listener_permission_step2 => '2. This app';

  @override
  String get permission_screen_notif_listener_permission_step3 =>
      '3. Turn on \"Allow notification access\"';

  @override
  String get permission_screen_overlay_window_permission_title =>
      'Overlay Window Permission';

  @override
  String get permission_screen_overlay_window_permission_instruction =>
      'This permission is required to display floating window on top of other apps.';

  @override
  String get permission_screen_overlay_window_permission_step1 =>
      '1. Grant Access button';

  @override
  String get permission_screen_overlay_window_permission_step2 => '2. This app';

  @override
  String get permission_screen_overlay_window_permission_step3 =>
      '3. Turn on \"Allow display over other apps\"';

  @override
  String get permission_screen_grant_access => 'Grant Access';

  @override
  String get permission_screen_done => 'Done';

  @override
  String get permission_screen_missing_permission => 'Missing Permission';

  @override
  String get permission_screen_enable_permissions =>
      'Please enable the permissions to proceed.';

  @override
  String get permission_screen_notification_access => 'Notification Access';

  @override
  String get permission_screen_display_window_over_apps =>
      'Display Window Over Apps';

  @override
  String get language => 'Language';

  @override
  String get language_english => 'English';

  @override
  String get language_chinese => '中文';

  @override
  String get home => 'Home';

  @override
  String get storedLyrics => 'Stored Lyrics';

  @override
  String get settings => 'Settings';

  @override
  String get home_screen_window_configs => 'Window Configs';

  @override
  String get home_screen_import_lyrics => 'Import Lyrics';

  @override
  String get home_screen_online_lyrics => 'Online Lyrics';

  @override
  String get lyric_list_import => 'Import';

  @override
  String get lyric_list_delete => 'Delete';

  @override
  String get lyric_list_delete_all => 'Delete All';

  @override
  String get lyric_list_cancel => 'Cancel';

  @override
  String get lyric_list_search => 'Search';

  @override
  String get lyric_list_filename => 'Filename';

  @override
  String get lyric_list_no_lyrics_found => 'No lyrics found.';

  @override
  String get lyric_list_delete_all_title => 'Delete All Lyric';

  @override
  String get lyric_list_delete_all_message =>
      'Are you sure you want to delete All lyrics?';

  @override
  String get lyric_list_delete_title => 'Delete Lyric';

  @override
  String get lyric_list_delete_message =>
      'Are you sure you want to delete this lyric?';

  @override
  String get lyric_list_error_deleting_lyrics => 'Error deleting lyrics.';

  @override
  String get lyric_list_error_deleting_lyric => 'Error deleting lyric.';

  @override
  String get lyric_detail_error_saving_lyric => 'Error saving lyric';

  @override
  String get lyric_detail_lyric_saved => 'Lyric saved';

  @override
  String get settings_use_dark_mode => 'Use Dark Mode';

  @override
  String get settings_color_scheme => 'Color Scheme';

  @override
  String get settings_bug_report_feature_request =>
      'Bug Report/Feature Request';

  @override
  String get settings_send_feedback => 'Send us your feedback';

  @override
  String get settings_known_issues => 'Known Issues';

  @override
  String get settings_known_issues_issue1 =>
      'In some heavy customized Android OS like MIUI, ColorOS, HuaWei: ';

  @override
  String get settings_known_issues_issue2 =>
      '1. Could not retrieve necessary permissions.';

  @override
  String get settings_known_issues_issue3 =>
      '2. Not detecting music app from notification bar.';

  @override
  String get overlay_window_hide => 'Hide';

  @override
  String get overlay_window_show => 'Show';

  @override
  String get overlay_window_styling => 'Styling';

  @override
  String get overlay_window_use_app_color => 'Use App Color';

  @override
  String get overlay_window_custom_background_color => 'Custom Backgound Color';

  @override
  String get overlay_window_pick_a_color => 'Pick a color!';

  @override
  String get overlay_window_got_it => 'Got it';

  @override
  String get overlay_window_opacity => 'Window Opacity';

  @override
  String get overlay_window_font_family => 'Font Family';

  @override
  String get overlay_window_lyrics_font_size => 'Lyrics Font Size';

  @override
  String get overlay_window_custom_text_color => 'Custom Text Color';

  @override
  String get overlay_window_element_visibilities => 'Element Visibilities';

  @override
  String get overlay_window_show_milliseconds => 'Show Milliseconds';

  @override
  String get overlay_window_hide_milliseconds => 'Hide Milliseconds';

  @override
  String get overlay_window_show_progress_bar => 'Show Progress Bar';

  @override
  String get overlay_window_hide_progress_bar => 'Hide Progress Bar';

  @override
  String get overlay_window_hide_no_lyrics_found_text =>
      'Hide \"No Lyrics Found\" Text';

  @override
  String get overlay_window_show_no_lyrics_found_text =>
      'Show \"No Lyrics Found\" Text';

  @override
  String get overlay_window_no_lyrics_found_subtitle =>
      'When no lyrics is found, toggle the text transparency.';

  @override
  String get overlay_window_show_line_2 => 'Show Line 2';

  @override
  String get overlay_window_hide_line_2 => 'Hide Line 2';

  @override
  String get overlay_window_enable_animation => 'Enable Animation';

  @override
  String get overlay_window_disable_animation => 'Disable Animation';

  @override
  String get overlay_window_tolerance => 'Tolerance';

  @override
  String get overlay_window_tolerance_subtitle =>
      'Increase this to make the lyrics ahead of the song, vice versa.';

  @override
  String get overlay_window_special_settings => 'Special Settings';

  @override
  String get overlay_window_ignore_touch => 'Ignore Touch';

  @override
  String get overlay_window_ignore_touch_subtitle =>
      'Enabling this will lock the window from moving too.\\nDisabling this will not unlock it.';

  @override
  String get overlay_window_touch_through => 'Touch Through';

  @override
  String get overlay_window_touch_through_subtitle =>
      'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\\nSuch issue is due to Android\'s design limitation and is out of this app\'s control. 🙏';

  @override
  String get fetch_online_auto_fetch => 'Auto Fetch';

  @override
  String get fetch_online_title => 'Title';

  @override
  String get fetch_online_artist => 'Artist';

  @override
  String get fetch_online_album => 'Album';

  @override
  String get fetch_online_duration => 'Duration';

  @override
  String get fetch_online_unknown => 'Unknown';

  @override
  String get fetch_online_powered_by => 'Powered by ';

  @override
  String get fetch_online_search => 'Search';

  @override
  String get fetch_online_lyric_fetch_result => 'Lyric Fetch Result';

  @override
  String get fetch_online_no_lyric_found => 'No lyric found for this song.';

  @override
  String get fetch_online_close => 'Close';

  @override
  String get fetch_online_save => 'Save';

  @override
  String get fetch_online_lyric_saved => 'Lyric saved';

  @override
  String get fetch_online_failed_to_save_lyric => 'Failed to save lyric';

  @override
  String get fetch_online_title_hint => 'Title of the song';

  @override
  String get fetch_online_artist_hint => 'Artist of the song';

  @override
  String get fetch_online_album_hint => 'Album of the song';

  @override
  String get import_local_lrc_your_lrc_file_format =>
      'Your LRC file should match one of the following formats:';

  @override
  String get import_local_lrc_file_name_format_1 => '1. File name should be:';

  @override
  String get import_local_lrc_file_name_format_2 => '2. File name should be:';

  @override
  String get import_local_lrc_file_should_contain => '3. File should contain:';

  @override
  String get import_local_lrc_importing => 'Importing...';

  @override
  String get import_local_lrc_import => 'Import';

  @override
  String get fail_import_dialog_title => 'Failed to Import Files:';

  @override
  String get fail_import_dialog_message =>
      'Please make sure the file is a valid .lrc file.';

  @override
  String get fail_import_dialog_learn_more =>
      'Tap here to learn supported file formats.';

  @override
  String get font_select_font_options => 'Font Options';

  @override
  String get font_select_reset_font_family => 'Reset font family';

  @override
  String get font_select_search_font => 'Search font';

  @override
  String get font_select_disclaimer =>
      'To save your internet data, limited options are loaded each time.\\nWe recommend visiting Google Fonts to view and feel the full list of fonts.\\nThen, you can search for the font name here and apply it.';

  @override
  String get font_select_visit_google_fonts => 'Visit Google Fonts';

  @override
  String get font_select_unknown => 'Unknown';

  @override
  String get error_dialog_title => 'Something went wrong';

  @override
  String get error_dialog_ok => 'OK';

  @override
  String get error_dialog_report => 'Report';

  @override
  String get overlay_window_no_lyric => 'No lyric';

  @override
  String get overlay_window_searching_lyric => 'Searching lyric...';

  @override
  String get overlay_window_waiting_for_music_player =>
      'Waiting for music player';

  @override
  String get media_state_play_song => 'Play a song';

  @override
  String get media_state_not_detecting_title =>
      'Not detecting active music player?';

  @override
  String get media_state_not_detecting_subtitle =>
      'Tap here to re-enable the notification listener';

  @override
  String get media_state_learn_more => 'Learn More';

  @override
  String get media_state_notification_listener_title => 'Notification Listener';

  @override
  String get media_state_notification_listener_info1 =>
      'On some Android devices (such as those from Huawei or Xiaomi), system-level battery and memory management features may restrict background services, including the notification listener required for music detection.';

  @override
  String get media_state_notification_listener_info2 =>
      'If the app is closed, these optimizations can terminate the background service after a short period, and it may not restart automatically.';

  @override
  String get media_state_notification_listener_info3 =>
      'If music is not being detected, please tap the button above to manually re-enable the notification listener.';

  @override
  String get media_state_notification_listener_info4 =>
      'Due to manufacturer-specific customizations and limited documentation, ensuring reliable background operation on these devices can be challenging. We appreciate your understanding as we continue to improve compatibility.';

  @override
  String get overlay_window_element_visibilities_title =>
      'Element Visibilities';

  @override
  String get overlay_window_special_settings_title => 'Special Settings';

  @override
  String get overlay_window_tolerance_title => 'Tolerance';

  @override
  String get overlay_window_ignore_touch_title => 'Ignore Touch';

  @override
  String get overlay_window_ignore_touch_subtitle_line1 =>
      'Enabling this will lock the window from moving too.';

  @override
  String get overlay_window_ignore_touch_subtitle_line2 =>
      'Disabling this will not unlock it.';

  @override
  String get overlay_window_touch_through_title => 'Touch Through';

  @override
  String get overlay_window_touch_through_subtitle_line1 =>
      'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.';

  @override
  String get overlay_window_touch_through_subtitle_line2 =>
      'Such issue is due to Android\'s design limitation and is out of this app\'s control. 🙏';

  @override
  String get animation_mode_fade_in => 'Fade In';

  @override
  String get animation_mode_typer => 'Typer';

  @override
  String get animation_mode_type_writer => 'Type Writer';
}
