part of 'lyric_state_listener_bloc.dart';

sealed class LyricStateListenerEvent {}

final class LyricStateListenerLoaded extends LyricStateListenerEvent {
  LyricStateListenerLoaded({
    required this.isAutoFetch,
    required this.showLine2,
  });

  final bool isAutoFetch;
  final bool showLine2;
}

final class AutoFetchUpdated extends LyricStateListenerEvent {
  AutoFetchUpdated({
    required this.isAutoFetch,
  });

  final bool isAutoFetch;
}

final class ShowLine2Updated extends LyricStateListenerEvent {
  ShowLine2Updated({
    required this.showLine2,
  });

  final bool showLine2;
}
