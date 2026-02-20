part of 'save_lrc_bloc.dart';

@freezed
sealed class SaveLrcEvent with _$SaveLrcEvent {
  const factory SaveLrcEvent.saveOnlineLrcResponse(
    LrcLibResponse lrcLibResponse,
  ) = _SaveOnlineLrcResponse;

  const factory SaveLrcEvent.saveLocalLrc(List<LrcModel> lrcs) = _SaveLocalLrc;
}
