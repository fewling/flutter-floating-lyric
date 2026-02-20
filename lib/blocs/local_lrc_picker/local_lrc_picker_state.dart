part of 'local_lrc_picker_bloc.dart';

@freezed
sealed class LocalLrcPickerState with _$LocalLrcPickerState {
  const factory LocalLrcPickerState({
    @Default(<LrcModel>[]) List<LrcModel> availableLrcs,
    @Default(<PlatformFile>[]) List<PlatformFile> failedFiles,
    @Default(ImportLocalLrcStatus.initial) ImportLocalLrcStatus status,
  }) = _LocalLrcPickerState;
}

enum ImportLocalLrcStatus { initial, loading, failed, success }

extension ImportLocalLrcStatusX on ImportLocalLrcStatus {
  bool get isInitial => this == ImportLocalLrcStatus.initial;
  bool get isLoading => this == ImportLocalLrcStatus.loading;
  bool get isFailed => this == ImportLocalLrcStatus.failed;
  bool get isSuccess => this == ImportLocalLrcStatus.success;
}
