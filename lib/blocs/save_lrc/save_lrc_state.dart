part of 'save_lrc_bloc.dart';

@freezed
sealed class SaveLrcState with _$SaveLrcState {
  const factory SaveLrcState({
    @Default(SaveLrcStatus.initial) SaveLrcStatus saveLrcStatus,
    @Default(<LrcModel>[]) List<LrcModel> lastSavedLrcs,
  }) = _SaveLrcState;
}

enum SaveLrcStatus { initial, loading, success, failure }

extension SaveLrcStatusX on SaveLrcStatus {
  bool get isInitial => this == SaveLrcStatus.initial;
  bool get isSaving => this == SaveLrcStatus.loading;
  bool get isSuccess => this == SaveLrcStatus.success;
  bool get isFailure => this == SaveLrcStatus.failure;
}
