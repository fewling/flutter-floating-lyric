import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lyric.dart';
import '../ui/lyric_window.dart';
import '../models/song.dart';
import 'song_box.dart';

class WindowController extends GetxController {
  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onReceive,
      onDidReceiveBackgroundNotificationResponse: onBackgroundReceive,
    );

    SharedPreferences.getInstance().then((value) {
      _prefs = value;

      _textColor.value = _prefs!.getInt('color') == null
          ? Colors.deepPurple.shade300
          : Color(_prefs!.getInt('color')!);

      _backgroundOpcity.value = _prefs!.getDouble('opacity') == null
          ? 0.0
          : _prefs!.getDouble('opacity')!;

      _widthProportion.value = _prefs!.getDouble('width') == null
          ? 100.0
          : _prefs!.getDouble('width')!;
    });
  }

  void onReceive(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    log('notification payload: $payload');
  }

  /// Functions passed to the [onDidReceiveBackgroundNotificationResponse] callback need to be
  /// annotated with the @pragma('vm:entry-point') annotation to ensure they are not stripped out by the Dart compiler.
  @pragma('vm:entry-point')
  static void onBackgroundReceive(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    log('Background Notification payload: $payload');
  }

  // non-reactive properties
  final _songBox = SongBox();
  final _lyricWindow = LyricWindow();
  var _playingSong = Song();
  var _millisLyric = <Map<int, String>>[];
  SharedPreferences? _prefs;
  double maxWidth = 1000;

  // reactive properties:
  final _displayingTitle = ''.obs;
  final _displayingLyric = ''.obs;
  final _isShowingWindow = false.obs;
  final _shouldShowWindow = false.obs;
  final _textColor = Colors.deepPurple.shade300.obs;
  final _backgroundOpcity = 0.0.obs;
  final _widthProportion = 100.0.obs;

  // getters
  String get displayingTitle => _displayingTitle.value;
  String get displayingLyric => _displayingLyric.value;
  Color get textColor => _textColor.value;
  double get backgroundOpcity => _backgroundOpcity.value;
  bool get isShowingWindow => _isShowingWindow.value;
  bool get shouldShowWindow => _shouldShowWindow.value;
  Song get song => _playingSong;
  double get widthProportion => _widthProportion.value;

  // setters
  set song(Song song) {
    // log('set song: $song, \nplayingSong: $_playingSong');

    // update lyric list when song changed:
    if (_playingSong.title != song.title) {
      _millisLyric = _updateLyricList(song);
      _displayingTitle.value = '${song.artist} - ${song.title}';
      _displayingLyric.value = '';
    }

    _playingSong = song;
    _updateWindow();
  }

  set textColor(Color color) {
    _textColor.value = color;
    _prefs?.setInt('color', color.value);
    _updateWindow(uiUpdate: true);
  }

  set backgroundOpcity(double opacity) {
    _backgroundOpcity.value = opacity;
    _prefs?.setDouble('opacity', opacity);
    _updateWindow(uiUpdate: true);
  }

  set widthProportion(double percentage) {
    _widthProportion.value = percentage;
    _prefs?.setDouble('width', percentage);
    _updateWindow(uiUpdate: true);
  }

  set isShowingWindow(bool isShowing) => _isShowingWindow.value = isShowing;

  set shouldShowWindow(bool shouldShow) {
    _shouldShowWindow.value = shouldShow;
    shouldShow ? _showWindow() : _closeWindow();
  }

  // methods
  void _showWindow() => _lyricWindow.show();

  void _closeWindow() {
    _playingSong = Song();
    _lyricWindow.close();
  }

  void _updateWindow({bool uiUpdate = false}) {
    _showNotificationWithChronometer();

    if (!shouldShowWindow) return;

    if (uiUpdate) {
      _lyricWindow.update();
    } else if (_millisLyric.isNotEmpty) {
      final currentDuration = int.parse(_playingSong.currentDuration);
      // log(_millisLyric.length.toString());

      for (final lyric in _millisLyric.reversed) {
        final timeKey = lyric.keys.first;
        if (currentDuration >= timeKey - 500) {
          var content = lyric[timeKey];

          if (_displayingLyric.value != content && content != null) {
            _displayingLyric.value = content;
            _lyricWindow.update();
          }
          break;
        }
      }
    } else if (_displayingLyric.value != 'No Lyric') {
      _displayingLyric.value = 'No Lyric';
      _lyricWindow.update();
    }
  }

  List<Map<int, String>> _updateLyricList(Song song) {
    final lyricList = <Map<int, String>>[];

    final artist = song.artist;
    final title = song.title;
    final key = '$artist - $title';

    if (!_songBox.hasKey(key)) return [];

    final lyric = Lyric.fromMap((_songBox.getSongMap(key)));
    const pattern = r'\[[0-9]{2}:[0-9]{2}.[0-9]{2}\]';
    final regExp = RegExp(pattern);

    for (final line in lyric.content) {
      Iterable<RegExpMatch> matches = regExp.allMatches(line);

      for (final m in matches) {
        final l = m.input;
        log('line: $l');

        final lastBracketIndex = l.lastIndexOf(']') + 1;
        final content = l.substring(lastBracketIndex);
        String time = l.substring(0, lastBracketIndex);

        while (time.contains(']')) {
          final index = time.indexOf(']') + 1;
          final t = time.substring(0, index);

          final minute = int.parse(t.substring(1, 3));
          final second = int.parse(t.substring(4, 6));
          final millis = int.parse(t.substring(7, 9));

          final millisTime = minute * 60 * 1000 + second * 1000 + millis;
          lyricList.add({millisTime: content});
          time = time.replaceRange(0, index, '');
        }
      }
    }

    lyricList.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    return lyricList;
  }

  Future<void> _showNotificationWithChronometer() async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      '515',
      'Floating Lyric Window Controller',
      channelDescription: 'Control the visibility of floating window',
      category: AndroidNotificationCategory.service,
      importance: Importance.low,
      priority: Priority.low,
      enableVibration: false,
      progress: int.tryParse(song.currentDuration) ?? 0,
      maxProgress: int.tryParse(song.maxDuration) ?? 0,
      showProgress: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await FlutterLocalNotificationsPlugin()
        .show(0, 'Floating Lyric Window Controller', 'Tab to app', details);
  }
}
