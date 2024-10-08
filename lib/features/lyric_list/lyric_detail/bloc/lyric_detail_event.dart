part of 'lyric_detail_bloc.dart';

sealed class LyricDetailEvent {
  const LyricDetailEvent();
}

final class LyricDetailLoaded extends LyricDetailEvent {
  const LyricDetailLoaded({this.id});
  final String? id;
}

final class SaveRequested extends LyricDetailEvent {
  const SaveRequested();
}

final class ContentUpdated extends LyricDetailEvent {
  const ContentUpdated(this.content);
  final String content;
}

final class SaveStatusReset extends LyricDetailEvent {
  const SaveStatusReset();
}
