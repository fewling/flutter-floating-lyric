import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/overlay_window/overlay_window_service.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_bloc.g.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required OverlayWindowService overlayWindowService,
  })  : _overlayWindowService = overlayWindowService,
        super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        LyricStateUpdated() => _onLyricUpdated(event, emit),
        OverlayWindowToggled() => _onToggled(event, emit),
      },
    );
  }
  final OverlayWindowService _overlayWindowService;

  void _onLyricUpdated(LyricStateUpdated event, Emitter<OverlayWindowState> emit) {
    final newState = state.copyWith(
      title: event.title,
      line1: event.line1,
      line2: event.line2,
      positionLeftLabel: event.positionLeftLabel,
      positionRightLabel: event.positionRightLabel,
      position: event.position,
    );

    _overlayWindowService.sendData(newState);
    emit(newState);
  }

  Future<void> _onToggled(OverlayWindowToggled event, Emitter<OverlayWindowState> emit) async {
    await _overlayWindowService.toggle();
  }
}
