import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/event_channels/media_states/media_state.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        HomeStarted() => _onStarted(event, emit),
      },
    );
  }

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {}
}
