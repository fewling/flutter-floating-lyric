import '../l10n/app_localizations.dart';

enum AnimationMode { fadeIn, typer, typeWriter }

extension AnimationModeExtension on AnimationMode {
  String label(AppLocalizations l10n) {
    switch (this) {
      case AnimationMode.fadeIn:
        return l10n.animation_mode_fade_in;
      case AnimationMode.typer:
        return l10n.animation_mode_typer;
      case AnimationMode.typeWriter:
        return l10n.animation_mode_type_writer;
    }
  }
}

AnimationMode animationModeFromJson(String str) {
  switch (str) {
    case 'fadeIn':
      return AnimationMode.fadeIn;
    case 'typer':
      return AnimationMode.typer;
    case 'typeWriter':
      return AnimationMode.typeWriter;
    default:
      return AnimationMode.fadeIn;
  }
}

String animationModeToJson(AnimationMode mode) {
  return mode.name;
}
