part of 'import_local_lrc_bloc.dart';

@freezed
class ImportLocalLrcState with _$ImportLocalLrcState {
  const factory ImportLocalLrcState({
    @Default(false) bool isProcessingFiles,
    @Default(<PlatformFile>[]) List<PlatformFile> failedFiles,
  }) = _ImportLocalLrcState;
}
