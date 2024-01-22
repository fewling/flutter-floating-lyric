import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/lyric_model.dart';

part 'lrc_detail_state.freezed.dart';

@freezed
class LyricDetailState with _$LyricDetailState {
  const factory LyricDetailState({
    @Default(null) LrcDB? lrcDB,
    @Default('') String originalContent,
  }) = _LyricDetailState;
}
