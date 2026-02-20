import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/overlay_window_config.dart';
import '../../services/platform_channels/method_channel_service.dart';
import '../preference/preference_bloc.dart';

part 'overlay_window_settings_bloc.freezed.dart';
part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';

class OverlayWindowSettingsBloc
    extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc({
    required MethodChannelService methodChannelService,
  }) : _methodChannelService = methodChannelService,
       super(const OverlayWindowSettingsState(config: OverlayWindowConfig())) {
    on<OverlayWindowSettingsEvent>(
      (event, emit) => switch (event) {
        _WindowVisibilityToggled() => _onVisibilityToggled(event, emit),
        _WindowIgnoreTouchToggled() => _onIgnoreTouchToggled(event, emit),
        _WindowTouchThroughToggled() => _onTouchThroughToggled(event, emit),
        _PreferenceUpdated() => _onPreferenceUpdated(event, emit),
      },
    );
  }

  final MethodChannelService _methodChannelService;

  Future<void> _onVisibilityToggled(
    _WindowVisibilityToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    final isSuccess = await switch (event.isVisible) {
      true => _methodChannelService.show(),
      false => _methodChannelService.hide(),
    };

    if (isSuccess ?? false) {
      emit(state.copyWith(isWindowVisible: event.isVisible));
    }
  }

  Future<void> _onIgnoreTouchToggled(
    _WindowIgnoreTouchToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    // TODO(@Felix)
    emit(
      state.copyWith(config: state.config.copyWith(ignoreTouch: event.value)),
    );
  }

  Future<void> _onTouchThroughToggled(
    _WindowTouchThroughToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    final isSuccess = await _methodChannelService.setTouchThru(event.value);

    if (isSuccess ?? false) {
      emit(
        state.copyWith(config: state.config.copyWith(touchThru: event.value)),
      );
    }
  }

  void _onPreferenceUpdated(
    _PreferenceUpdated event,
    Emitter<OverlayWindowSettingsState> emit,
  ) {
    final pref = event.state;
    emit(
      state.copyWith(
        config: state.config.copyWith(
          appColorScheme: pref.appColorScheme,
          fontFamily: pref.fontFamily,
          fontSize: pref.fontSize.toDouble(),
          locale: pref.locale,
          visibleLinesCount: pref.visibleLinesCount,
          showMillis: pref.showMilliseconds,
          showProgressBar: pref.showProgressBar,
          transparentNotFoundTxt: pref.transparentNotFoundTxt,
          useAppColor: pref.useAppColor,
          backgroundColor: pref.backgroundColor,
          color: pref.color,
          opacity: pref.opacity,
          isLight: pref.isLight,
          tolerance: pref.tolerance.toDouble(),
        ),
      ),
    );
  }
}
