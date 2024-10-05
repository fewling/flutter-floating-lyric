import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/permissions/permission_service.dart';
import '../../../services/event_channels/media_states/media_state.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PermissionService permissionService,
  })  : _permissionService = permissionService,
        super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        HomeStarted() => _onStarted(event, emit),
        StartMusicPlayerRequested() => _onStartMusicPlayerRequested(event, emit),
        MediaStateChanged() => _onMediaStateChanged(event, emit),
      },
    );
  }

  final PermissionService _permissionService;

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      mediaState: event.mediaState,
    ));
  }

  void _onStartMusicPlayerRequested(StartMusicPlayerRequested event, Emitter<HomeState> emit) {
    _permissionService.start3rdMusicPlayer();
  }

  void _onMediaStateChanged(MediaStateChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      mediaState: event.mediaState,
    ));
  }
}
