part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class FeedbackEmailClicked extends SettingsEvent {
  const FeedbackEmailClicked();
}
