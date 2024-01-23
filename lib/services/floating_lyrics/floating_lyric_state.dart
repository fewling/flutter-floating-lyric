import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lrc.dart';
import '../event_channels/media_states/media_state.dart';

part 'floating_lyric_state.freezed.dart';

@freezed
class FloatingLyricState with _$FloatingLyricState {
  const factory FloatingLyricState({
    @Default(null) MediaState? mediaState,
    Lrc? currentLrc,
    String? currentLine,
  }) = _FloatingLyricState;
}
