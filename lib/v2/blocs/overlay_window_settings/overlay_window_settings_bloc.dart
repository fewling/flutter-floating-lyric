import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_settings_model.dart';
import '../../services/platform_channels/method_channel_service.dart';

part 'overlay_window_settings_bloc.freezed.dart';
part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';

class OverlayWindowSettingsBloc
    extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc({
    required MethodChannelService methodChannelService,
  }) : _methodChannelService = methodChannelService,
       super(
         const OverlayWindowSettingsState(settings: OverlaySettingsModel()),
       ) {
    on<OverlayWindowSettingsEvent>(
      (event, emit) => switch (event) {
        _WindowVisibilityToggled() => _onVisibilityToggled(event, emit),
        _WindowIgnoreTouchToggled() => _onIgnoreTouchToggled(event, emit),
        _WindowTouchThroughToggled() => _onTouchThroughToggled(event, emit),
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
      state.copyWith(
        settings: state.settings.copyWith(ignoreTouch: event.value),
      ),
    );
  }

  Future<void> _onTouchThroughToggled(
    _WindowTouchThroughToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) async {
    final isSuccess = await _methodChannelService.setTouchThru(event.value);

    if (isSuccess ?? false) {
      emit(
        state.copyWith(
          settings: state.settings.copyWith(touchThru: event.value),
        ),
      );
    }
  }
}
