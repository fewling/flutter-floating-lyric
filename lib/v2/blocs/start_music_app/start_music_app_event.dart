part of 'start_music_app_bloc.dart';

@freezed
sealed class StartMusicAppEvent with _$StartMusicAppEvent {
  const factory StartMusicAppEvent.startMusicApp() = _StartMusicApp;
}
