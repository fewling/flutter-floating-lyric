part of 'import_local_lrc_bloc.dart';

@freezed
sealed class ImportLocalLrcEvent with _$ImportLocalLrcEvent {
  const factory ImportLocalLrcEvent.started() = _Started;
  const factory ImportLocalLrcEvent.importLRCsRequested() =
      _ImportLRCsRequested;
  const factory ImportLocalLrcEvent.importStatusHandled() =
      _ImportStatusHandled;
}
