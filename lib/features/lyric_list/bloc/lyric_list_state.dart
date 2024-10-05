part of 'lyric_list_bloc.dart';

@freezed
class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcDB>[]) List<LrcDB> lyrics,
    @Default(LyricListDeleteStatus.initial) LyricListDeleteStatus deleteStatus,
    @Default(LyricListImportStatus.initial) LyricListImportStatus importStatus,
    @Default(<PlatformFile>[]) List<PlatformFile> failedImportFiles,
  }) = _LyricListState;
}

enum LyricListDeleteStatus { initial, deleted, error }

enum LyricListImportStatus { initial, importing, error }

extension LyricListDeleteStatusX on LyricListDeleteStatus {
  bool get isInitial => this == LyricListDeleteStatus.initial;
  bool get isDeleted => this == LyricListDeleteStatus.deleted;
  bool get isError => this == LyricListDeleteStatus.error;
}

extension LyricListImportStatusX on LyricListImportStatus {
  bool get isInitial => this == LyricListImportStatus.initial;
  bool get isImporting => this == LyricListImportStatus.importing;
  bool get isError => this == LyricListImportStatus.error;
}
