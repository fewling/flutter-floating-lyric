part of 'font_selection_bloc.dart';

@freezed
sealed class FontSelectionEvent with _$FontSelectionEvent {
  const factory FontSelectionEvent.started() = _Started;
  const factory FontSelectionEvent.loadMore() = _LoadMore;
  const factory FontSelectionEvent.search(String searchTerm) = _Search;
}
