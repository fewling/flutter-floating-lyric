part of 'app_info_bloc.dart';

@freezed
sealed class AppInfoEvent with _$AppInfoEvent {
  const factory AppInfoEvent.started() = _Started;
}
