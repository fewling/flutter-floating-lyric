import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_settings_model.dart';
import '../../../service/message_channels/to_overlay_message_service.dart';
import '../../../service/overlay_window/overlay_window_service.dart';
import '../../../service/platform_methods/window_channel_service.dart';
import '../../../utils/extensions/custom_extensions.dart';
import '../../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../../preference/bloc/preference_bloc.dart';

part 'overlay_window_settings_bloc.freezed.dart';
part 'overlay_window_settings_bloc.g.dart';
part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';

class OverlayWindowSettingsBloc extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc({
    required ToOverlayMessageService toOverlayMessageService,
    required OverlayWindowService overlayWindowService,
    required WindowChannelService windowChannelService,
  })  : _toOverlayMessageService = toOverlayMessageService,
        _overlayWindowService = overlayWindowService,
        _windowChannelService = windowChannelService,
        super(const OverlayWindowSettingsState()) {
    on<OverlayWindowSettingsEvent>(
      (event, emit) => switch (event) {
        OverlayWindowSettingsLoaded() => _onLoaded(event, emit),
        PreferenceUpdated() => _onPreferenceUpdated(event, emit),
        LyricStateListenerUpdated() => _onLyricStateListenerUpdated(event, emit),
        OverlayWindowVisibilityToggled() => _onVisibilityToggled(event, emit),
        LyricOnlyModeToggled() => _onLyricOnlyModeToggled(event, emit),
      },
    );
  }

  final OverlayWindowService _overlayWindowService;
  final ToOverlayMessageService _toOverlayMessageService;
  final WindowChannelService _windowChannelService;

  Future<void> _onLoaded(OverlayWindowSettingsLoaded event, Emitter<OverlayWindowSettingsState> emit) async {
    final pref = event.preferenceState;
    final lyric = event.lyricStateListenerState;

    final pos = Duration(milliseconds: lyric.mediaState?.position.toInt() ?? 0);
    final max = Duration(milliseconds: lyric.mediaState?.duration.toInt() ?? 0);

    final leftLabel = pos.mmss();
    final rightLabel = max.mmss();

    final newState = state.copyWith(
      settings: state.settings.copyWith(
        // pref:
        color: pref.color,
        fontSize: pref.fontSize.toDouble(),
        opacity: pref.opacity,
        showMillis: pref.showMilliseconds,
        showProgressBar: pref.showProgressBar,
        isLight: pref.isLight,
        appColorScheme: pref.appColorScheme,

        // lyric:
        line1: lyric.line1,
        line2: lyric.line2,
        position: lyric.mediaState?.position,
        positionLeftLabel: leftLabel,
        positionRightLabel: rightLabel,
        title: lyric.mediaState?.title,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendSettings(newState.settings);

    await emit.forEach(
      _overlayWindowService.isActive,
      onData: (isActive) => state.copyWith(isWindowVisible: isActive),
    );
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
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendSettings(newState.settings);
  }

  void _onLyricStateListenerUpdated(LyricStateListenerUpdated event, Emitter<OverlayWindowSettingsState> emit) {
    final lyric = event.lyricStateListenerState;

    final pos = Duration(milliseconds: lyric.mediaState?.position.toInt() ?? 0);
    final max = Duration(milliseconds: lyric.mediaState?.duration.toInt() ?? 0);

    final leftLabel = pos.mmss();
    final rightLabel = max.mmss();

    final newState = state.copyWith(
      settings: state.settings.copyWith(
        line1: lyric.line1,
        line2: lyric.line2,
        position: lyric.mediaState?.position,
        positionLeftLabel: leftLabel,
        positionRightLabel: rightLabel,
        title: lyric.mediaState?.title,
      ),
    );

    emit(newState);
    _toOverlayMessageService.sendSettings(newState.settings);
  }

  Future<void> _onVisibilityToggled(
    OverlayWindowVisibilityToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    if (event.isVisible) {
      _windowChannelService.show();
    } else {
      _windowChannelService.hide();
    }
    // final renderObj = homeScreenOverlayWindowMeasureKey.currentContext?.findRenderObject();
    // final height = renderObj?.semanticBounds.size.height.toInt() ?? 0;

    // await _overlayWindowService.toggle(height: height);
  }

  void _onLyricOnlyModeToggled(LyricOnlyModeToggled event, Emitter<OverlayWindowSettingsState> emit) {
    OverlayWindowSettingsState newState;
    if (state.settings.showLyricOnly == null) {
      newState = state.copyWith(
        settings: state.settings.copyWith(showLyricOnly: true),
      );
    } else {
      final showLyricOnly = !state.settings.showLyricOnly!;
      newState = state.copyWith(
        settings: state.settings.copyWith(showLyricOnly: showLyricOnly),
      );
    }

    emit(newState);
    _toOverlayMessageService.sendSettings(newState.settings);
  }
}
