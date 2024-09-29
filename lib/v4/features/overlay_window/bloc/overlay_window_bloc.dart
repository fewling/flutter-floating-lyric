import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_bloc.g.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc() : super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        LyricStateUpdated() => _onLyricUpdated(event, emit),
      },
    );
  }

  void _onLyricUpdated(LyricStateUpdated event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(
      title: event.title,
      line1: event.line1,
      line2: event.line2,
      positionLeftLabel: event.positionLeftLabel,
      positionRightLabel: event.positionRightLabel,
      position: event.position,
    ));
  }
}
