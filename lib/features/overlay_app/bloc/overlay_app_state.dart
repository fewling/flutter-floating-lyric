part of 'overlay_app_bloc.dart';

@freezed
class OverlayAppState with _$OverlayAppState {
  const factory OverlayAppState({
    @Default('HI') String debugText,
  }) = _OverlayAppState;

  factory OverlayAppState.fromJson(Map<String, dynamic> json) => _$OverlayAppStateFromJson(json);
}
