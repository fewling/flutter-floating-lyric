enum SearchLyricStatus {
  initial,
  empty,
  searching,
  found,
  notFound,
}

extension SearchLyricStatusX on SearchLyricStatus {
  bool get isInitial => this == SearchLyricStatus.initial;
  bool get isEmpty => this == SearchLyricStatus.empty;
  bool get isSearching => this == SearchLyricStatus.searching;
  bool get isFound => this == SearchLyricStatus.found;
  bool get isNotFound => this == SearchLyricStatus.notFound;
}

SearchLyricStatus searchLyricStatusFromJson(String? status) {
  switch (status) {
    case 'empty':
      return SearchLyricStatus.empty;
    case 'searching':
      return SearchLyricStatus.searching;
    case 'found':
      return SearchLyricStatus.found;
    case 'notFound':
      return SearchLyricStatus.notFound;
    default:
      return SearchLyricStatus.initial;
  }
}

String searchLyricStatusToJson(SearchLyricStatus status) {
  switch (status) {
    case SearchLyricStatus.empty:
      return 'empty';
    case SearchLyricStatus.searching:
      return 'searching';
    case SearchLyricStatus.found:
      return 'found';
    case SearchLyricStatus.notFound:
      return 'notFound';
    case SearchLyricStatus.initial:
      return 'initial';
  }
}
