part of 'device_info_listener_bloc.dart';

sealed class DeviceInfoListenerEvent {
  const DeviceInfoListenerEvent();
}

final class DeviceInfoListenerLoaded extends DeviceInfoListenerEvent {
  const DeviceInfoListenerLoaded({
    required this.devicePixelRatio,
  });

  final double devicePixelRatio;
}
