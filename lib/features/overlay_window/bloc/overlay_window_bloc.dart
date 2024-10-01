import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/overlay_window_settings.dart';
import '../../../service/overlay_window/overlay_window_service.dart';
import '../../overlay_app/for_main_sides/overlay_window_measurer.dart';

part 'overlay_window_bloc.freezed.dart';
part 'overlay_window_bloc.g.dart';
part 'overlay_window_event.dart';
part 'overlay_window_state.dart';

class OverlayWindowBloc extends Bloc<OverlayWindowEvent, OverlayWindowState> {
  OverlayWindowBloc({
    required OverlayWindowService overlayWindowService,
    required this.devicePixelRatio,
  })  : _overlayWindowService = overlayWindowService,
        super(const OverlayWindowState()) {
    on<OverlayWindowEvent>(
      (event, emit) => switch (event) {
        OverlayWindowLoaded() => _onLoaded(event, emit),
        LyricStateUpdated() => _onLyricUpdated(event, emit),
        OverlayWindowToggled() => _onToggled(event, emit),
        WindowStyleUpdated() => _onStyleUpdated(event, emit),
      },
    );
  }

  final OverlayWindowService _overlayWindowService;
  final double devicePixelRatio;

  Future<void> _onLoaded(OverlayWindowLoaded event, Emitter<OverlayWindowState> emit) async {
    emit(state.copyWith(
      settings: state.settings.copyWith(
        height: _getHeight().toInt(),
        opacity: event.opacity,
        color: event.color,
        fontSize: event.fontSize.toDouble(),
        showProgressBar: event.showProgressBar,
        showMillis: event.showMillis,
      ),
    ));

    await emit.forEach(
      _overlayWindowService.isActive,
      onData: (isActive) => state.copyWith(
        settings: state.settings.copyWith(
          isWindowVisible: isActive,
        ),
      ),
    );
  }

  void _onLyricUpdated(LyricStateUpdated event, Emitter<OverlayWindowState> emit) {
    final renderObj = overlayWindowMeasureKey.currentContext?.findRenderObject();
    final syze = renderObj?.semanticBounds.size;

    final newState = state.copyWith(
      settings: state.settings.copyWith(
        title: event.title,
        line1: event.line1,
        line2: event.line2,
        positionLeftLabel: event.positionLeftLabel,
        positionRightLabel: event.positionRightLabel,
        position: event.position,
      ),
    );

    _overlayWindowService.sendData(newState);
    emit(newState);
  }

  Future<void> _onToggled(OverlayWindowToggled event, Emitter<OverlayWindowState> emit) async {
    await _overlayWindowService.toggle(
      height: (state.settings.height * devicePixelRatio).toInt() + 2, // +2 for floored value
    );

    _overlayWindowService.sendData(state);
  }

  void _onStyleUpdated(WindowStyleUpdated event, Emitter<OverlayWindowState> emit) {
    emit(state.copyWith(
      settings: state.settings.copyWith(
        fontSize: event.fontSize.toDouble(),
        opacity: event.opacity,
        color: event.color,
        showProgressBar: event.showProgressBar,
        showMillis: event.showMillis,
        height: _getHeight().toInt(),
      ),
    ));

    _overlayWindowService.resizeWindow(_getHeight().toInt());
  }

  double _getHeight() {
    final renderObj = overlayWindowMeasureKey.currentContext?.findRenderObject();
    final syze = renderObj?.semanticBounds.size;

    return syze?.height ?? state.settings.height.toDouble();
  }
}
