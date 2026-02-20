part of 'start_music_app_bloc.dart';

@freezed
sealed class StartMusicAppState with _$StartMusicAppState {
  const factory StartMusicAppState.initial() = _Initial;
}
