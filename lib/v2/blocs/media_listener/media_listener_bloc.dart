import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/event_channels/media_states/media_state.dart';
import '../../../service/event_channels/media_states/media_state_event_channel.dart';

part 'media_listener_bloc.freezed.dart';
part 'media_listener_event.dart';
part 'media_listener_state.dart';

class MediaListenerBloc extends Bloc<MediaListenerEvent, MediaListenerState> {
  MediaListenerBloc() : super(const MediaListenerState()) {
    on<MediaListenerEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
      },
    );
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<MediaListenerState> emit,
  ) async {
    await emit.onEach(
      mediaStateStream,
      onData: (data) => emit(state.copyWith(mediaStates: data)),
    );
  }
}
