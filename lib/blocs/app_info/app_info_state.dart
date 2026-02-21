part of 'app_info_bloc.dart';

@freezed
sealed class AppInfoState with _$AppInfoState {
  const factory AppInfoState({String? version, String? buildNumber}) =
      _AppInfoState;
}
