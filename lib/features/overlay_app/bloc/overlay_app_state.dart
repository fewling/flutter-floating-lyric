part of 'overlay_app_bloc.dart';

@freezed
class OverlayAppState with _$OverlayAppState {
  const factory OverlayAppState({
    @Default(OverlayMode.full) OverlayMode mode,
  }) = _OverlayAppState;

  factory OverlayAppState.fromJson(Map<String, dynamic> json) => _$OverlayAppStateFromJson(json);
}

enum OverlayMode { full, lyricOnly }

extension OverlayModeX on OverlayMode {
  bool get isFull => this == OverlayMode.full;
  bool get isLyricOnly => this == OverlayMode.lyricOnly;
}
