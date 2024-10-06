part of 'font_select_bloc.dart';

sealed class FontSelectEvent {
  const FontSelectEvent();
}

final class FontSelectStarted extends FontSelectEvent {
  const FontSelectStarted();
}

final class FontSelectSearchChanged extends FontSelectEvent {
  const FontSelectSearchChanged(this.searchTerm);

  final String searchTerm;
}
