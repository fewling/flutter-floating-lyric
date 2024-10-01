import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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

  void _onStarted(OverlayAppStarted event, Emitter<OverlayAppState> emit) {
    emit.forEach(
      FlutterOverlayWindow.overlayListener,
      onData: (data) {
        try {
          final json = jsonDecode(data.toString());
          final state = OverlayAppState.fromJson(json as Map<String, dynamic>);
          return state;
        } catch (e) {
          return const OverlayAppState();
        }
      },
    );
  }
}
