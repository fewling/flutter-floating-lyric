import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/song.dart';

part 'floating_window_state.freezed.dart';

final floatingStateProvider =
    NotifierProvider<FloatingStateNotifier, FloatingState>(FloatingStateNotifier.new);

class FloatingStateNotifier extends Notifier<FloatingState> {
  @override
  FloatingState build() {
    return FloatingState(
      displayingTitle: '',
      displayingLyric: '',
      isShowingWindow: false,
      shouldShowWindow: false,
      song: Song(),
      textColor: Colors.deepPurple.shade300,
      backgroundOpacity: 0,
      widthProportion: 100,
    );
  }

  void toggleWindowVisibility(bool? value) =>
      state = state.copyWith(shouldShowWindow: value ?? false);

  void updateBackgroundOpacity(double value) => state = state.copyWith(backgroundOpacity: value);

  void updateWidthProportion(double value) => state = state.copyWith(widthProportion: value);

  void updateTextColor(Color value) => state = state.copyWith(textColor: value);

  void updateSong(Song song) => state = state.copyWith(song: song);
}

@freezed
class FloatingState with _$FloatingState {
  const factory FloatingState({
    required String displayingTitle,
    required String displayingLyric,
    required bool isShowingWindow,
    required bool shouldShowWindow,
    required Song song,
    required Color textColor,
    required double backgroundOpacity,
    required double widthProportion,
    @Default(1000) double maxWidth,
  }) = _FloatingState;
}

// class WindowController extends GetxController {
//   Future<void> init() async {
//     SharedPreferences.getInstance().then((value) {
//       _prefs = value;

//       _textColor.value = _prefs!.getInt('color') == null
//           ? Colors.deepPurple.shade300
//           : Color(_prefs!.getInt('color')!);

//       _backgroundOpacity.value =
//           _prefs!.getDouble('opacity') == null ? 0.0 : _prefs!.getDouble('opacity')!;

//       _widthProportion.value =
//           _prefs!.getDouble('width') == null ? 100.0 : _prefs!.getDouble('width')!;
//     });
//   }

//   // non-reactive properties
//   final _songBox = SongBox();
//   final _lyricWindow = LyricWindow();
//   var _playingSong = Song();
//   var _millisLyric = <Map<int, String>>[];
//   SharedPreferences? _prefs;
//   double maxWidth = 1000;

//   // reactive properties:
//   final _displayingTitle = ''.obs;
//   final _displayingLyric = ''.obs;
//   final _isShowingWindow = false.obs;
//   final _shouldShowWindow = false.obs;
//   final _textColor = Colors.deepPurple.shade300.obs;
//   final _backgroundOpacity = 0.0.obs;
//   final _widthProportion = 100.0.obs;

//   // getters
//   String get displayingTitle => _displayingTitle.value;
//   String get displayingLyric => _displayingLyric.value;
//   Color get textColor => _textColor.value;
//   double get backgroundOpacity => _backgroundOpacity.value;
//   bool get isShowingWindow => _isShowingWindow.value;
//   bool get shouldShowWindow => _shouldShowWindow.value;
//   Song get song => _playingSong;
//   double get widthProportion => _widthProportion.value;

//   // setters
//   set song(Song song) {
//     // log('set song: $song, \nplayingSong: $_playingSong');

//     // update lyric list when song changed:
//     if (_playingSong.title != song.title) {
//       _millisLyric = _updateLyricList(song);
//       _displayingTitle.value = '${song.artist} - ${song.title}';
//       _displayingLyric.value = '';
//     }

//     _playingSong = song;
//     _updateWindow();
//   }

//   set textColor(Color color) {
//     _textColor.value = color;
//     _prefs?.setInt('color', color.value);
//     _updateWindow(uiUpdate: true);
//   }

//   set backgroundOpacity(double opacity) {
//     _backgroundOpacity.value = opacity;
//     _prefs?.setDouble('opacity', opacity);
//     _updateWindow(uiUpdate: true);
//   }

//   set widthProportion(double percentage) {
//     _widthProportion.value = percentage;
//     _prefs?.setDouble('width', percentage);
//     _updateWindow(uiUpdate: true);
//   }

//   set isShowingWindow(bool isShowing) => _isShowingWindow.value = isShowing;

//   set shouldShowWindow(bool shouldShow) {
//     _shouldShowWindow.value = shouldShow;
//     shouldShow ? _showWindow() : _closeWindow();
//   }

//   // methods
//   void _showWindow() => _lyricWindow.show();

//   void _closeWindow() {
//     _playingSong = Song();
//     _lyricWindow.close();
//   }

//   void _updateWindow({bool uiUpdate = false}) {
//     if (!shouldShowWindow) return;

//     if (uiUpdate) {
//       _lyricWindow.update();
//     } else if (_millisLyric.isNotEmpty) {
//       final currentDuration = int.parse(_playingSong.currentDuration);
//       // log(_millisLyric.length.toString());

//       for (final lyric in _millisLyric.reversed) {
//         final timeKey = lyric.keys.first;
//         if (currentDuration >= timeKey - 500) {
//           var content = lyric[timeKey];

//           if (_displayingLyric.value != content && content != null) {
//             _displayingLyric.value = content;
//             _lyricWindow.update();
//           }
//           break;
//         }
//       }
//     } else if (_displayingLyric.value != 'No Lyric') {
//       _displayingLyric.value = 'No Lyric';
//       _lyricWindow.update();
//     }
//   }

//   List<Map<int, String>> _updateLyricList(Song song) {
//     final lyricList = <Map<int, String>>[];

//     final artist = song.artist;
//     final title = song.title;
//     final key = '$artist - $title';

//     if (!_songBox.hasKey(key)) return [];

//     final lyric = Lyric.fromMap((_songBox.getSongMap(key)));
//     const pattern = r'\[[0-9]{2}:[0-9]{2}.[0-9]{2}\]';
//     final regExp = RegExp(pattern);

//     for (final line in lyric.content) {
//       Iterable<RegExpMatch> matches = regExp.allMatches(line);

//       for (final m in matches) {
//         final l = m.input;
//         log('line: $l');

//         final lastBracketIndex = l.lastIndexOf(']') + 1;
//         final content = l.substring(lastBracketIndex);
//         String time = l.substring(0, lastBracketIndex);

//         while (time.contains(']')) {
//           final index = time.indexOf(']') + 1;
//           final t = time.substring(0, index);

//           final minute = int.parse(t.substring(1, 3));
//           final second = int.parse(t.substring(4, 6));
//           final millis = int.parse(t.substring(7, 9));

//           final millisTime = minute * 60 * 1000 + second * 1000 + millis;
//           lyricList.add({millisTime: content});
//           time = time.replaceRange(0, index, '');
//         }
//       }
//     }

//     lyricList.sort((a, b) => a.keys.first.compareTo(b.keys.first));
//     return lyricList;
//   }
// }
