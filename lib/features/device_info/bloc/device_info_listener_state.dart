part of 'device_info_listener_bloc.dart';

@freezed
class DeviceInfoListenerState with _$DeviceInfoListenerState {
  const factory DeviceInfoListenerState({
    @Default(1.0) double devicePixelRatio,
  }) = _DeviceInfoListenerState;

  factory DeviceInfoListenerState.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoListenerStateFromJson(json);
}
