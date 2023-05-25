import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../lyric_list/lyric_list_screen.dart';
import '../lyric_screen/lyric_screen.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(0)
        int screenIndex,
    @Default(<ChildMetaData>[
      ChildMetaData(title: 'Floating Window', child: LyricScreen()),
      ChildMetaData(title: 'Stored Lyric', child: LyricListScreen()),
    ])
        List<ChildMetaData> screens,
  }) = _MainState;
}

@freezed
class ChildMetaData with _$ChildMetaData {
  const factory ChildMetaData({
    @Default('') String title,
    required Widget child,
  }) = _ChildMetaData;
}
