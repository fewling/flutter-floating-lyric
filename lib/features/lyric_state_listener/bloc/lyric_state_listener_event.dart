part of 'lyric_state_listener_bloc.dart';

sealed class LyricStateListenerEvent {
  const LyricStateListenerEvent();
}

final class LyricStateListenerLoaded extends LyricStateListenerEvent {
  const LyricStateListenerLoaded({
    required this.isAutoFetch,
    required this.showLine2,
  });

  final bool isAutoFetch;
  final bool showLine2;
}

final class AutoFetchUpdated extends LyricStateListenerEvent {
  const AutoFetchUpdated({
    required this.isAutoFetch,
  });

  final bool isAutoFetch;
}

final class ShowLine2Updated extends LyricStateListenerEvent {
  const ShowLine2Updated({
    required this.showLine2,
  });

  final bool showLine2;
}

final class StartMusicPlayerRequested extends LyricStateListenerEvent {
  const StartMusicPlayerRequested();
}

final class NewLyricSaved extends LyricStateListenerEvent {
  const NewLyricSaved();
}
