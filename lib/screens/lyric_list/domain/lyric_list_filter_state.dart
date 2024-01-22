import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_list_filter_state.freezed.dart';

@freezed
class LyricListFilterState with _$LyricListFilterState {
  const factory LyricListFilterState({
    @Default(null) String? searchTerm,
  }) = _LyricListFilterState;
}
