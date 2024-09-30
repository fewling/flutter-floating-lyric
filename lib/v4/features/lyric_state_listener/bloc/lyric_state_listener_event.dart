part of 'lyric_state_listener_bloc.dart';

sealed class LyricStateListenerEvent {}

final class LyricStateListenerLoaded extends LyricStateListenerEvent {
  LyricStateListenerLoaded({
    required this.isAutoFetch,
  });

  final bool isAutoFetch;
}

final class AutoFetchUpdated extends LyricStateListenerEvent {
  AutoFetchUpdated({
    required this.isAutoFetch,
  });

  final bool isAutoFetch;
}
