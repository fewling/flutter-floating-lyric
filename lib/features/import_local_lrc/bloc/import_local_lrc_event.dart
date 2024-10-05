part of 'import_local_lrc_bloc.dart';

sealed class ImportLocalLrcEvent {
  const ImportLocalLrcEvent();
}

final class ImportLocalLrcStarted extends ImportLocalLrcEvent {
  const ImportLocalLrcStarted();
}

final class ImportLRCsRequested extends ImportLocalLrcEvent {
  const ImportLRCsRequested();
}
