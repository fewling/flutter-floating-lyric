part of 'app_info_bloc.dart';

sealed class AppInfoEvent {
  const AppInfoEvent();
}

final class AppInfoLoaded extends AppInfoEvent {
  const AppInfoLoaded();
}
