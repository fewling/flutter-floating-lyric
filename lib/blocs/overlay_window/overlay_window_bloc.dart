import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/search_lyric_status.dart';
import '../../models/lrc.dart';
import '../../models/media_state.dart';
import '../../models/overlay_window_config.dart';
import '../../models/to_main_msg.dart';
import '../../services/msg_channels/to_main_msg_service.dart';
import '../../services/platform_channels/layout_channel_service.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required ToMainMsgService toMainMsgService,
    required LayoutChannelService layoutChannelService,
  }) : _toMainMsgService = toMainMsgService,
       _layoutChannelService = layoutChannelService,
       super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _CloseRequested() => _onCloseRequested(event, emit),
        _WindowTapped() => _onWindowTapped(event, emit),
        _WindowResized() => _onWindowResized(event, emit),
        _LockToggled() => _onLockToggled(event, emit),
        _LyricStateUpdated() => _onLyricStateUpdated(event, emit),
        _MediaStateUpdated() => _onMediaStateUpdated(event, emit),
        _WindowConfigsUpdated() => _onWindowConfigsUpdated(event, emit),
      },
    );
  }

  final ToMainMsgService _toMainMsgService;
  final LayoutChannelService _layoutChannelService;

  void _onStarted(_Started event, Emitter<OverlayWindowState> emit) {}

  void _onCloseRequested(
    _CloseRequested event,
    Emitter<OverlayWindowState> emit,
  ) => _toMainMsgService.sendMsg(const ToMainMsg.closeOverlay());

  void _onWindowTapped(_WindowTapped event, Emitter<OverlayWindowState> emit) =>
      emit(state.copyWith(isLyricOnly: !state.isLyricOnly));

  void _onWindowResized(
    _WindowResized event,
    Emitter<OverlayWindowState> emit,
  ) => _layoutChannelService.setLayout(event.width, event.height);

  Future<void> _onLockToggled(
    _LockToggled event,
    Emitter<OverlayWindowState> emit,
  ) async {
    final isSuccess = await _layoutChannelService.toggleLock(event.isLocked);

    if (isSuccess != null && isSuccess) {
      emit(state.copyWith(isLocked: event.isLocked));
    }
  }

  void _onLyricStateUpdated(
    _LyricStateUpdated event,
    Emitter<OverlayWindowState> emit,
  ) {
    emit(
      state.copyWith(currentLrc: event.lrc, lyricSearchStatus: event.status),
    );
    _syncLyric(emit);
  }

  void _onMediaStateUpdated(
    _MediaStateUpdated event,
    Emitter<OverlayWindowState> emit,
  ) {
    emit(state.copyWith(mediaState: event.mediaState));
    _syncLyric(emit);
  }

  void _onWindowConfigsUpdated(
    _WindowConfigsUpdated event,
    Emitter<OverlayWindowState> emit,
  ) {
    emit(state.copyWith(config: event.config));
    _syncLyric(emit);
  }

  void _syncLyric(Emitter<OverlayWindowState> emit) {
    final mediaState = state.mediaState;
    final config = state.config;
    final lrc = state.currentLrc;

    if (mediaState == null) return;

    if (lrc == null) {
      emit(state.copyWith(allLines: [], currentLineIndex: 0));
      return;
    }

    final position = mediaState.position;
    final tolerance = config?.tolerance ?? 0;

    // Find the current line index based on position
    var currentIndex = 0;
    for (var i = lrc.lines.length - 1; i >= 0; i--) {
      if (position >= (lrc.lines[i].time.inMilliseconds - tolerance)) {
        currentIndex = i;
        break;
      }
    }

    // Pass all lines to the UI, let ListView handle scrolling
    emit(state.copyWith(allLines: lrc.lines, currentLineIndex: currentIndex));
  }
}
