import 'package:freezed_annotation/freezed_annotation.dart';

import 'floating_overlay_state_types.dart';
import 'overlay_window_lyric_state.dart';
import 'overlay_window_style_state.dart';

part 'floating_overlay_event.freezed.dart';
part 'floating_overlay_event.g.dart';

@freezed
class FloatingOverlayEvent with _$FloatingOverlayEvent {
  const factory FloatingOverlayEvent({
    required FloatingOverlayStateTypes type,
    OverlayWindowLyricState? lyricState,
    OverlayWindowStyleState? styleState,
  }) = _FloatingOverlayEvent;

  factory FloatingOverlayEvent.fromJson(Map<String, dynamic> json) => _$FloatingOverlayEventFromJson(json);
}
