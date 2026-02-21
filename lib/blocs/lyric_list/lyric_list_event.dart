part of 'lyric_list_bloc.dart';

@freezed
sealed class LyricListEvent with _$LyricListEvent {
  const factory LyricListEvent.started() = _Started;
  const factory LyricListEvent.searchUpdated(String searchTerm) =
      _SearchUpdated;
  const factory LyricListEvent.deleteRequested(LrcModel lyric) =
      _DeleteRequested;
  const factory LyricListEvent.deleteAllRequested() = _DeleteAllRequested;
  const factory LyricListEvent.importLRCsRequested() = _ImportLRCsRequested;
  const factory LyricListEvent.deleteStatusHandled() = _DeleteStatusHandled;
}
