part of 'custom_extensions.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
