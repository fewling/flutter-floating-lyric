import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_app_bloc.freezed.dart';
part 'overlay_app_bloc.g.dart';
part 'overlay_app_event.dart';
part 'overlay_app_state.dart';

class OverlayAppBloc extends Bloc<OverlayAppEvent, OverlayAppState> {
  OverlayAppBloc() : super(const OverlayAppState()) {
    on<OverlayAppEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _MinimizeRequested() => _onMinimizeRequested(event, emit),
        _MaximizeRequested() => _onMaximizeRequested(event, emit),
      },
    );
  }

  void _onStarted(_Started event, Emitter<OverlayAppState> emit) {}

  void _onMinimizeRequested(
    _MinimizeRequested event,
    Emitter<OverlayAppState> emit,
  ) {
    emit(state.copyWith(isMinimized: true));
  }

  void _onMaximizeRequested(
    _MaximizeRequested event,
    Emitter<OverlayAppState> emit,
  ) {
    emit(state.copyWith(isMinimized: false));
  }
}
