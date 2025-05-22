import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_listener_bloc.freezed.dart';
part 'device_info_listener_bloc.g.dart';
part 'device_info_listener_event.dart';
part 'device_info_listener_state.dart';

class DeviceInfoListenerBloc
    extends Bloc<DeviceInfoListenerEvent, DeviceInfoListenerState> {
  DeviceInfoListenerBloc() : super(const DeviceInfoListenerState()) {
    on<DeviceInfoListenerEvent>(
      (event, emit) => switch (event) {
        DeviceInfoListenerLoaded() => _onLoaded(event, emit),
      },
    );
  }

  void _onLoaded(
    DeviceInfoListenerLoaded event,
    Emitter<DeviceInfoListenerState> emit,
  ) {
    emit(state.copyWith(devicePixelRatio: event.devicePixelRatio));
  }
}
