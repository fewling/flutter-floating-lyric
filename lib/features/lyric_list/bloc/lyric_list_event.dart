part of 'lyric_list_bloc.dart';

sealed class LyricListEvent {
  const LyricListEvent();
}

final class LyricListLoaded extends LyricListEvent {
  const LyricListLoaded();
}

final class SearchUpdated extends LyricListEvent {
  const SearchUpdated(this.searchTerm);
  final String searchTerm;
}

final class DeleteRequested extends LyricListEvent {
  const DeleteRequested(this.lyric);
  final LrcDB lyric;
}

final class DeleteAllRequested extends LyricListEvent {
  const DeleteAllRequested();
}

final class ImportLRCsRequested extends LyricListEvent {
  const ImportLRCsRequested();
}
