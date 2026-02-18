part of 'msg_from_main_bloc.dart';

@freezed
sealed class MsgFromMainState with _$MsgFromMainState {
  const factory MsgFromMainState({
    required OverlaySettingsModel? settings,
    required MediaState? mediaState,
  }) = _MsgFromMainState;
}
