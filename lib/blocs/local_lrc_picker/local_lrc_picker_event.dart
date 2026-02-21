part of 'local_lrc_picker_bloc.dart';

@freezed
sealed class LocalLrcPickerEvent with _$LocalLrcPickerEvent {
  const factory LocalLrcPickerEvent.importLRCsRequested() =
      _ImportLRCsRequested;
}
