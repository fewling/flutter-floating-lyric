import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services/platform_channels/method_channel_service.dart';

part 'start_music_app_bloc.freezed.dart';
part 'start_music_app_event.dart';
part 'start_music_app_state.dart';

class StartMusicAppBloc extends Bloc<StartMusicAppEvent, StartMusicAppState> {
  StartMusicAppBloc({required MethodChannelService methodChannelService})
    : _methodChannelService = methodChannelService,
      super(const _Initial()) {
    on<StartMusicAppEvent>(
      (event, emit) => switch (event) {
        _StartMusicApp() => _onStartMusicApp(event, emit),
      },
    );
  }

  final MethodChannelService _methodChannelService;

  void _onStartMusicApp(
    StartMusicAppEvent event,
    Emitter<StartMusicAppState> emit,
  ) => _methodChannelService.start3rdMusicPlayer();
}
