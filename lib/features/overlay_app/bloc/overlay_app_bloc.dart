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
        OverlayAppStarted() => _onStarted(event, emit),
      },
    );
  }

  void _onStarted(OverlayAppStarted event, Emitter<OverlayAppState> emit) {}
}
