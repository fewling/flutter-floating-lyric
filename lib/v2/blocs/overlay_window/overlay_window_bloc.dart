import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/from_overlay_msg_model.dart';
import '../../../models/lrc.dart';
import '../../../service/event_channels/media_states/media_state.dart';
import '../../../service/message_channels/to_main_message_service.dart';
import '../../models/overlay_window_config.dart';
import '../../services/platform_channels/layout_channel_service.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required ToMainMessageService toMainMessageService,
    required LayoutChannelService layoutChannelService,
  }) : _toMainMessageService = toMainMessageService,
       _layoutChannelService = layoutChannelService,
       super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _CloseRequested() => _onCloseRequested(event, emit),
        _WindowTapped() => _onWindowTapped(event, emit),
        _WindowResized() => _onWindowResized(event, emit),
        _LockToggled() => _onLockToggled(event, emit),
        _ScreenWidthRequested() => _onScreenWidthRequested(event, emit),
        _LyricFound() => _onLyricFound(event, emit),
        _MediaStateUpdated() => _onMediaStateUpdated(event, emit),
        _WindowConfigsUpdated() => _onWindowConfigsUpdated(event, emit),
      },
    );
  }

  final ToMainMessageService _toMainMessageService;
  final LayoutChannelService _layoutChannelService;

  void _onStarted(_Started event, Emitter<OverlayWindowState> emit) {}

  void _onCloseRequested(
    _CloseRequested event,
    Emitter<OverlayWindowState> emit,
  ) {
    _toMainMessageService.sendMsg(
      const FromOverlayMsgModel(action: OverlayAction.close),
    );
  }

  void _onWindowTapped(_WindowTapped event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(isLyricOnly: !state.isLyricOnly));
  }

  void _onWindowResized(
    _WindowResized event,
    Emitter<OverlayWindowState> emit,
  ) {
    _layoutChannelService.setLayout(event.width, event.height);
  }

  Future<void> _onLockToggled(
    _LockToggled event,
    Emitter<OverlayWindowState> emit,
  ) async {
    final isSuccess = await _layoutChannelService.toggleLock(event.isLocked);

    if (isSuccess != null && isSuccess) {
      emit(state.copyWith(isLocked: event.isLocked));
    }
  }

  void _onScreenWidthRequested(
    _ScreenWidthRequested event,
    Emitter<OverlayWindowState> emit,
  ) {
    _toMainMessageService.sendMsg(
      const FromOverlayMsgModel(action: OverlayAction.measureScreenWidth),
    );
  }

  void _onLyricFound(_LyricFound event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(currentLrc: event.lrc));
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
      emit(state.copyWith(line1: null, line2: null));
      return;
    }

    final position = mediaState.position;
    final tolerance = config.tolerance ?? 0;
    final showLine2 = config.showLine2 ?? false;
    if (showLine2) {
      final oddLines = lrc.lines
          .whereIndexed((index, _) => index.isOdd)
          .toList();
      final evenLines = lrc.lines
          .whereIndexed((index, _) => index.isEven)
          .toList();

      var line1 = state.line1;
      var line2 = state.line2;

      for (final line in oddLines.reversed) {
        if (position > (line.time.inMilliseconds - tolerance) ||
            line == lrc.lines.first) {
          line2 = line;
          break;
        }
      }

      for (final line in evenLines.reversed) {
        if (position > (line.time.inMilliseconds - tolerance) ||
            line == lrc.lines.first) {
          line1 = line;
          break;
        }
      }
      emit(state.copyWith(line1: line1, line2: line2));
    } else {
      final currentLine = lrc.lines.lastWhere(
        (line) => line.time.inMilliseconds <= mediaState.position,
        orElse: () => lrc.lines.first,
      );

      emit(state.copyWith(line1: currentLine, line2: null));
    }
  }
}
