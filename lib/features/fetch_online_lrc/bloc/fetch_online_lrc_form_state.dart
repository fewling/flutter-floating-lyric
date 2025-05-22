part of 'fetch_online_lrc_form_bloc.dart';

@freezed
class FetchOnlineLrcFormState with _$FetchOnlineLrcFormState {
  const factory FetchOnlineLrcFormState({
    String? title,
    String? artist,
    String? album,
    String? titleAlt,
    String? artistAlt,
    String? albumAlt,
    double? duration,
    @Default(false) bool isEditingTitle,
    @Default(false) bool isEditingArtist,
    @Default(false) bool isEditingAlbum,
    @Default(null) LrcLibResponse? lrcLibResponse,
    @Default(OnlineLrcRequestStatus.initial)
    OnlineLrcRequestStatus requestStatus,
    @Default(SaveLrcStatus.initial) SaveLrcStatus saveLrcStatus,
  }) = _FetchOnlineLrcFormState;
}

enum OnlineLrcRequestStatus { initial, loading, success, failure }

enum SaveLrcStatus { initial, saving, success, failure }

extension OnlineLrcRequestStatusX on OnlineLrcRequestStatus {
  bool get isInitial => this == OnlineLrcRequestStatus.initial;
  bool get isLoading => this == OnlineLrcRequestStatus.loading;
  bool get isSuccess => this == OnlineLrcRequestStatus.success;
  bool get isFailure => this == OnlineLrcRequestStatus.failure;
}

extension SaveLrcStatusX on SaveLrcStatus {
  bool get isInitial => this == SaveLrcStatus.initial;
  bool get isSaving => this == SaveLrcStatus.saving;
  bool get isSuccess => this == SaveLrcStatus.success;
  bool get isFailure => this == SaveLrcStatus.failure;
}
