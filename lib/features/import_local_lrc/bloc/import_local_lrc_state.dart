part of 'import_local_lrc_bloc.dart';

@freezed
class ImportLocalLrcState with _$ImportLocalLrcState {
  const factory ImportLocalLrcState({
    @Default(<PlatformFile>[]) List<PlatformFile> failedFiles,
    @Default(ImportLocalLrcStatus.initial) ImportLocalLrcStatus status,
  }) = _ImportLocalLrcState;
}

enum ImportLocalLrcStatus { initial, processingFiles, failed, success }

extension ImportLocalLrcStatusX on ImportLocalLrcStatus {
  bool get isInitial => this == ImportLocalLrcStatus.initial;
  bool get isProcessingFiles => this == ImportLocalLrcStatus.processingFiles;
  bool get isFailed => this == ImportLocalLrcStatus.failed;
  bool get isSuccess => this == ImportLocalLrcStatus.success;
}
