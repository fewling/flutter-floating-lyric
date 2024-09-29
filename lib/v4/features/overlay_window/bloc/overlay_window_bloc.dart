import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/overlay_window/overlay_window_service.dart';
import '../overlay_window_measurer.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_bloc.g.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required OverlayWindowService overlayWindowService,
    required double devicePixelRatio,
  })  : _overlayWindowService = overlayWindowService,
        super(OverlayWindowState(
          devicePixelRatio: devicePixelRatio,
        )) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        OverlayWindowLoaded() => _onLoaded(event, emit),
        LyricStateUpdated() => _onLyricUpdated(event, emit),
        OverlayWindowToggled() => _onToggled(event, emit),
        OverlayWindowSizeChanged() => _onSizeChanged(event, emit),
        WindowStyleUpdated() => _onStyleUpdated(event, emit),
      },
    );
  }

  final OverlayWindowService _overlayWindowService;

  void _onLoaded(OverlayWindowLoaded event, Emitter<OverlayWindowState> emit) {
    add(const OverlayWindowSizeChanged());
  }

  void _onLyricUpdated(LyricStateUpdated event, Emitter<OverlayWindowState> emit) {
    final renderObj = overlayWindowMeasureKey.currentContext?.findRenderObject();
    final syze = renderObj?.semanticBounds.size;

    final newState = state.copyWith(
      title: event.title,
      line1: event.line1,
      line2: event.line2,
      positionLeftLabel: event.positionLeftLabel,
      positionRightLabel: event.positionRightLabel,
      position: event.position,
      height: syze?.height.toInt() ?? state.height,
    );

    _overlayWindowService.sendData(newState);
    emit(newState);
  }

  Future<void> _onToggled(OverlayWindowToggled event, Emitter<OverlayWindowState> emit) async {
    await _overlayWindowService.toggle(
      height: (state.height * state.devicePixelRatio).toInt() + 2, // +2 for floored value
    );
  }

  void _onSizeChanged(OverlayWindowSizeChanged event, Emitter<OverlayWindowState> emit) {
    final renderObj = overlayWindowMeasureKey.currentContext?.findRenderObject();
    final syze = renderObj?.semanticBounds.size;

    emit(state.copyWith(
      height: syze?.height.toInt() ?? state.height,
    ));
  }

  void _onStyleUpdated(WindowStyleUpdated event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(
      fontSize: event.fontSize.toDouble(),
      opacity: event.opacity,
      color: event.color,
      showProgressBar: event.showProgressBar,
      showMillis: event.showMillis,
    ));
  }
}
