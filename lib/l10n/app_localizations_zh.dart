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
  String get permission_screen_notif_listener_permission_instruction =>
      '此應用需要存取通知列中的音樂播放器才能正常運作。';

  @override
  String get permission_screen_notif_listener_permission_step1 => '1. 授予存取權限按鈕';

  @override
  String get permission_screen_notif_listener_permission_step2 => '2. 此應用程式';

  @override
  String get permission_screen_notif_listener_permission_step3 =>
      '3. 開啟「允許通知存取」';

  @override
  String get permission_screen_overlay_window_permission_title => '浮窗權限';

  @override
  String get permission_screen_overlay_window_permission_instruction =>
      '需要此權限才能在其他應用程式上方顯示浮動視窗。';

  @override
  String get permission_screen_overlay_window_permission_step1 => '1. 授予存取權限按鈕';

  @override
  String get permission_screen_overlay_window_permission_step2 => '2. 此應用程式';

  @override
  String get permission_screen_overlay_window_permission_step3 =>
      '3. 開啟「允許顯示在其他應用程式上層」';

  @override
  String get permission_screen_grant_access => '授予存取權限';

  @override
  String get permission_screen_done => '完成';

  @override
  String get permission_screen_missing_permission => '缺少權限';

  @override
  String get permission_screen_enable_permissions => '請啟用權限以繼續。';

  @override
  String get permission_screen_notification_access => '通知存取';

  @override
  String get permission_screen_display_window_over_apps => '在其他應用程式上層顯示視窗';

  @override
  String get home => '首頁';

  @override
  String get storedLyrics => '本地歌詞';

  @override
  String get settings => '設定';

  @override
  String get home_screen_window_configs => '視窗設定';

  @override
  String get home_screen_import_lyrics => '匯入歌詞';

  @override
  String get home_screen_online_lyrics => '線上歌詞';

  @override
  String get lyric_list_import => '匯入';

  @override
  String get lyric_list_delete => '刪除';

  @override
  String get lyric_list_delete_all => '全部刪除';

  @override
  String get lyric_list_cancel => '取消';

  @override
  String get lyric_list_search => '搜尋';

  @override
  String get lyric_list_filename => '檔案名稱';

  @override
  String get lyric_list_no_lyrics_found => '找不到歌詞。';

  @override
  String get lyric_list_delete_all_title => '刪除所有歌詞';

  @override
  String get lyric_list_delete_all_message => '您確定要刪除所有歌詞嗎？';

  @override
  String get lyric_list_delete_title => '刪除歌詞';

  @override
  String get lyric_list_delete_message => '您確定要刪除此歌詞嗎？';

  @override
  String get lyric_list_error_deleting_lyrics => '刪除歌詞時發生錯誤。';

  @override
  String get lyric_list_error_deleting_lyric => '刪除歌詞時發生錯誤。';

  @override
  String get lyric_detail_error_saving_lyric => '儲存歌詞時發生錯誤';

  @override
  String get lyric_detail_lyric_saved => '歌詞已儲存';

  @override
  String get settings_use_dark_mode => '使用深色模式';

  @override
  String get settings_color_scheme => '色彩主題';

  @override
  String get settings_bug_report_feature_request => '錯誤回報/功能請求';

  @override
  String get settings_send_feedback => '傳送您的意見回饋';

  @override
  String get settings_known_issues => '已知問題';

  @override
  String get settings_known_issues_issue1 =>
      '在某些高度客製化的 Android 系統（如 MIUI、ColorOS、華為）中：';

  @override
  String get settings_known_issues_issue2 => '1. 無法取得必要的權限。';

  @override
  String get settings_known_issues_issue3 => '2. 無法從通知列偵測音樂應用程式。';

  @override
  String get overlay_window_hide => '隱藏';

  @override
  String get overlay_window_show => '顯示';

  @override
  String get overlay_window_styling => '樣式';

  @override
  String get overlay_window_use_app_color => '使用應用程式顏色';

  @override
  String get overlay_window_custom_background_color => '自訂背景顏色';

  @override
  String get overlay_window_pick_a_color => '選擇顏色！';

  @override
  String get overlay_window_got_it => '知道了';

  @override
  String get overlay_window_opacity => '視窗不透明度';

  @override
  String get overlay_window_font_family => '字型';

  @override
  String get overlay_window_lyrics_font_size => '歌詞字型大小';

  @override
  String get overlay_window_custom_text_color => '自訂文字顏色';

  @override
  String get overlay_window_element_visibilities => '元素可見性';

  @override
  String get overlay_window_show_milliseconds => '顯示毫秒';

  @override
  String get overlay_window_hide_milliseconds => '隱藏毫秒';

  @override
  String get overlay_window_show_progress_bar => '顯示進度列';

  @override
  String get overlay_window_hide_progress_bar => '隱藏進度列';

  @override
  String get overlay_window_hide_no_lyrics_found_text => '隱藏「找不到歌詞」文字';

  @override
  String get overlay_window_show_no_lyrics_found_text => '顯示「找不到歌詞」文字';

  @override
  String get overlay_window_no_lyrics_found_subtitle => '當找不到歌詞時，切換文字透明度。';

  @override
  String get overlay_window_show_line_2 => '顯示第二行';

  @override
  String get overlay_window_hide_line_2 => '隱藏第二行';

  @override
  String get overlay_window_enable_animation => '啟用動畫';

  @override
  String get overlay_window_disable_animation => '停用動畫';

  @override
  String get overlay_window_tolerance => '容差';

  @override
  String get overlay_window_tolerance_subtitle => '增加此值使歌詞提前顯示，反之亦然。';

  @override
  String get overlay_window_special_settings => '特殊設定';

  @override
  String get overlay_window_ignore_touch => '忽略觸控';

  @override
  String get overlay_window_ignore_touch_subtitle =>
      '啟用此功能將鎖定視窗移動。\\n停用此功能不會解鎖視窗。';

  @override
  String get overlay_window_touch_through => '觸控穿透';

  @override
  String get overlay_window_touch_through_subtitle =>
      '這會停用返回手勢、鍵盤等功能。請自行承擔風險。\\n此問題是由於 Android 設計限制，超出此應用程式的控制範圍。🙏';

  @override
  String get fetch_online_auto_fetch => '自動取得';

  @override
  String get fetch_online_title => '標題';

  @override
  String get fetch_online_artist => '演出者';

  @override
  String get fetch_online_album => '專輯';

  @override
  String get fetch_online_duration => '時長';

  @override
  String get fetch_online_unknown => '未知';

  @override
  String get fetch_online_powered_by => '技術支援 ';

  @override
  String get fetch_online_search => '搜尋';

  @override
  String get fetch_online_lyric_fetch_result => '歌詞取得結果';

  @override
  String get fetch_online_no_lyric_found => '找不到此歌曲的歌詞。';

  @override
  String get fetch_online_close => '關閉';

  @override
  String get fetch_online_save => '儲存';

  @override
  String get fetch_online_lyric_saved => '歌詞已儲存';

  @override
  String get fetch_online_failed_to_save_lyric => '儲存歌詞失敗';

  @override
  String get fetch_online_title_hint => '歌曲標題';

  @override
  String get fetch_online_artist_hint => '歌曲演出者';

  @override
  String get fetch_online_album_hint => '歌曲專輯';

  @override
  String get import_local_lrc_your_lrc_file_format => '您的 LRC 檔案應符合以下格式之一：';

  @override
  String get import_local_lrc_file_name_format_1 => '1. 檔案名稱應為：';

  @override
  String get import_local_lrc_file_name_format_2 => '2. 檔案名稱應為：';

  @override
  String get import_local_lrc_file_should_contain => '3. 檔案應包含：';

  @override
  String get import_local_lrc_importing => '匯入中...';

  @override
  String get import_local_lrc_import => '匯入';

  @override
  String get fail_import_dialog_title => '匯入檔案失敗：';

  @override
  String get fail_import_dialog_message => '請確保檔案是有效的 .lrc 檔案。';

  @override
  String get fail_import_dialog_learn_more => '點擊此處了解支援的檔案格式。';

  @override
  String get font_select_font_options => '字型選項';

  @override
  String get font_select_reset_font_family => '重設字型';

  @override
  String get font_select_search_font => '搜尋字型';

  @override
  String get font_select_disclaimer =>
      '為節省您的網路流量，每次載入的選項有限。\\n我們建議造訪 Google Fonts 檢視完整字型清單。\\n然後，您可以在此處搜尋字型名稱並套用。';

  @override
  String get font_select_visit_google_fonts => '造訪 Google Fonts';

  @override
  String get font_select_unknown => '未知';

  @override
  String get error_dialog_title => '發生錯誤';

  @override
  String get error_dialog_ok => '確定';

  @override
  String get error_dialog_report => '回報';

  @override
  String get overlay_window_no_lyric => '無歌詞';

  @override
  String get overlay_window_searching_lyric => '搜尋歌詞中...';

  @override
  String get overlay_window_waiting_for_music_player => '等待音樂播放器';

  @override
  String get media_state_play_song => '播放歌曲';

  @override
  String get media_state_not_detecting_title => '未偵測到音樂播放器?';

  @override
  String get media_state_not_detecting_subtitle => '點擊此處重新啟用通知監聽器';

  @override
  String get media_state_learn_more => '了解更多';

  @override
  String get media_state_notification_listener_title => '通知監聽器';

  @override
  String get media_state_notification_listener_info1 =>
      '在某些 Android 裝置(如華為或小米)上,系統層級的電池和記憶體管理功能可能會限制背景服務,包括音樂偵測所需的通知監聽器。';

  @override
  String get media_state_notification_listener_info2 =>
      '如果應用程式關閉,這些最佳化可能會在短時間後終止背景服務,且可能不會自動重新啟動。';

  @override
  String get media_state_notification_listener_info3 =>
      '如果無法偵測到音樂,請點擊上方按鈕手動重新啟用通知監聽器。';

  @override
  String get media_state_notification_listener_info4 =>
      '由於製造商的特定客製化和有限的文件,確保在這些裝置上可靠的背景運作可能具有挑戰性。我們感謝您的理解,並將持續改善相容性。';

  @override
  String get overlay_window_element_visibilities_title => '元素可見性';

  @override
  String get overlay_window_special_settings_title => '特殊設定';

  @override
  String get overlay_window_tolerance_title => '容差';

  @override
  String get overlay_window_ignore_touch_title => '忽略觸控';

  @override
  String get overlay_window_ignore_touch_subtitle_line1 => '啟用此功能將鎖定視窗移動。';

  @override
  String get overlay_window_ignore_touch_subtitle_line2 => '停用此功能不會解鎖視窗。';

  @override
  String get overlay_window_touch_through_title => '觸控穿透';

  @override
  String get overlay_window_touch_through_subtitle_line1 =>
      '這會停用返回手勢、鍵盤等功能。請自行承擔風險。';

  @override
  String get overlay_window_touch_through_subtitle_line2 =>
      '此問題是由於 Android 設計限制，超出此應用程式的控制範圍。🙏';
}
