part of 'lyric_detail_bloc.dart';

@freezed
sealed class LyricDetailEvent with _$LyricDetailEvent {
  const factory LyricDetailEvent.started({required String id}) = _Started;
  const factory LyricDetailEvent.saveRequested() = _SaveRequested;
  const factory LyricDetailEvent.contentUpdated(String content) =
      _ContentUpdated;
  const factory LyricDetailEvent.saveStatusReset() = _SaveStatusReset;
}
