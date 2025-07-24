part of 'lyric_detail_bloc.dart';

@freezed
sealed class LyricDetailState with _$LyricDetailState {
  const factory LyricDetailState({
    @Default(null) LrcDB? lrcDB,
    @Default('') String originalContent,
    @Default(LyricSaveStatus.initial) LyricSaveStatus saveStatus,
  }) = _LyricDetailState;
}

enum LyricSaveStatus { initial, saved, error }

extension LyricSaveStatusX on LyricSaveStatus {
  bool get isInitial => this == LyricSaveStatus.initial;
  bool get isSaved => this == LyricSaveStatus.saved;
  bool get isError => this == LyricSaveStatus.error;
}
