import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_settings_event.dart';
part 'overlay_window_settings_state.dart';
part 'overlay_window_settings_bloc.freezed.dart';

class OverlayWindowSettingsBloc extends Bloc<OverlayWindowSettingsEvent, OverlayWindowSettingsState> {
  OverlayWindowSettingsBloc() : super(_Initial()) {
    on<OverlayWindowSettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
