import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_settings_model.dart';
import '../../../models/to_overlay_msg_model.dart';
import '../../../service/message_channels/to_overlay_message_service.dart';
import '../../../service/platform_methods/window_channel_service.dart';
import '../../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../../preference/bloc/preference_bloc.dart';

part 'overlay_window_settings_bloc.freezed.dart';
part 'overlay_window_settings_bloc.g.dart';
part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';

class OverlayWindowSettingsBloc extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc({
    required ToOverlayMessageService toOverlayMessageService,
    required WindowChannelService windowChannelService,
  })  : _toOverlayMessageService = toOverlayMessageService,
        _windowChannelService = windowChannelService,
        super(const OverlayWindowSettingsState()) {
    on<OverlayWindowSettingsEvent>(
      (event, emit) => switch (event) {
        OverlayWindowSettingsLoaded() => _onLoaded(event, emit),
        PreferenceUpdated() => _onPreferenceUpdated(event, emit),
        LyricStateListenerUpdated() => _onLyricStateListenerUpdated(event, emit),
        OverlayWindowVisibilityToggled() => _onVisibilityToggled(event, emit),
        WindowIgnoreTouchToggled() => _onIgnoreTouchToggled(event, emit),
        WindowTouchThruToggled() => _onTouchThruToggled(event, emit),
        WindowThemeToggled() => _onThemeToggled(event, emit),
      },
    );
  }

  final ToOverlayMessageService _toOverlayMessageService;
  final WindowChannelService _windowChannelService;

  Future<void> _onLoaded(OverlayWindowSettingsLoaded event, Emitter<OverlayWindowSettingsState> emit) async {
    final pref = event.preferenceState;
    final lyric = event.lyricStateListenerState;

    final isWindowVisible = await _windowChannelService.isActive();

    final title = '${lyric.mediaState?.title} - ${lyric.mediaState?.artist}';

    final newState = state.copyWith(
      isWindowVisible: isWindowVisible ?? false,
      settings: state.settings.copyWith(
        width: event.screenWidth,

        // pref:
        color: pref.color,
        fontSize: pref.fontSize.toDouble(),
        opacity: pref.opacity,
        showMillis: pref.showMilliseconds,
        showProgressBar: pref.showProgressBar,
        isLight: pref.isLight,
        appColorScheme: pref.appColorScheme,
        showLine2: pref.showLine2,

        // lyric:
        line1: lyric.line1,
        line2: lyric.line2,
        position: lyric.mediaState?.position,
        duration: lyric.mediaState?.duration,
        // positionLeftLabel: leftLabel,
        // positionRightLabel: rightLabel,
        title: title,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendMsg(ToOverlayMsgModel(settings: newState.settings));
  }

  void _onPreferenceUpdated(PreferenceUpdated event, Emitter<OverlayWindowSettingsState> emit) {
    final pref = event.preferenceState;

    final newState = state.copyWith(
      settings: state.settings.copyWith(
        color: pref.color,
        fontSize: pref.fontSize.toDouble(),
        opacity: pref.opacity,
        showMillis: pref.showMilliseconds,
        showProgressBar: pref.showProgressBar,
        isLight: pref.isLight,
        appColorScheme: pref.appColorScheme,
        showLine2: pref.showLine2,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendMsg(ToOverlayMsgModel(settings: newState.settings));
  }

  void _onLyricStateListenerUpdated(LyricStateListenerUpdated event, Emitter<OverlayWindowSettingsState> emit) {
    final lyric = event.lyricStateListenerState;

    final title = '${lyric.mediaState?.title} - ${lyric.mediaState?.artist}';

    final newState = state.copyWith(
      settings: state.settings.copyWith(
        line1: lyric.line1,
        line2: lyric.line2,
        position: lyric.mediaState?.position,
        duration: lyric.mediaState?.duration,
        title: title,
        searchLyricStatus: lyric.searchLyricStatus,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendMsg(ToOverlayMsgModel(settings: newState.settings));
  }

  Future<void> _onVisibilityToggled(
    OverlayWindowVisibilityToggled ev,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    final isSuccess = ev.shouldVisible ? await _windowChannelService.show() : await _windowChannelService.hide();

    if (isSuccess != null && isSuccess) {
      emit(state.copyWith(
        isWindowVisible: ev.shouldVisible,
      ));
    }
  }

  Future<void> _onIgnoreTouchToggled(WindowIgnoreTouchToggled event, Emitter<OverlayWindowSettingsState> emit) async {
    final newState = state.copyWith(
      settings: state.settings.copyWith(
        ignoreTouch: event.isIgnored,
      ),
    );
    emit(newState);

    _toOverlayMessageService.sendMsg(ToOverlayMsgModel(
      settings: newState.settings,
    ));
  }

  Future<void> _onTouchThruToggled(WindowTouchThruToggled event, Emitter<OverlayWindowSettingsState> emit) async {
    final newState = state.copyWith(
      settings: state.settings.copyWith(
        touchThru: event.isTouchThru,
      ),
    );

    final isSuccessful = await _windowChannelService.setTouchThru(event.isTouchThru);
    if (isSuccessful != null && isSuccessful) {
      emit(newState);
    }
  }

  void _onThemeToggled(WindowThemeToggled event, Emitter<OverlayWindowSettingsState> emit) {
    final newState = state.copyWith(
      settings: state.settings.copyWith(
        useAppColor: event.useAppColor,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendMsg(ToOverlayMsgModel(settings: newState.settings));
  }
}
