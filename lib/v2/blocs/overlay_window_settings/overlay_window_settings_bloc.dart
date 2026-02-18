import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_settings_model.dart';

part 'overlay_window_settings_bloc.freezed.dart';
part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';

class OverlayWindowSettingsBloc
    extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc()
    : super(
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

  void _onVisibilityToggled(
    _WindowVisibilityToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) => emit(state.copyWith(isWindowVisible: event.isVisible));

  void _onIgnoreTouchToggled(
    _WindowIgnoreTouchToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) => emit(
    state.copyWith(settings: state.settings.copyWith(ignoreTouch: event.value)),
  );

  void _onTouchThroughToggled(
    _WindowTouchThroughToggled event,
    Emitter<OverlayWindowSettingsState> emit,
  ) => emit(
    state.copyWith(settings: state.settings.copyWith(touchThru: event.value)),
  );
}
