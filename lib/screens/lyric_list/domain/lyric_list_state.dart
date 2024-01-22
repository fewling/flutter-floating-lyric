import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/lyric_model.dart';

part 'lyric_list_state.freezed.dart';

@freezed
class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcDB>[]) List<LrcDB> lyrics,
  }) = _LyricListState;
}
