import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/lyric_list_filter_state.dart';

part 'lyric_list_filter_notifier.g.dart';

@riverpod
class LyricListFilterNotifier extends _$LyricListFilterNotifier {
  @override
  LyricListFilterState build() {
    return const LyricListFilterState();
  }

  void setSearchTerm(String value) {
    state = state.copyWith(searchTerm: value);
  }
}
