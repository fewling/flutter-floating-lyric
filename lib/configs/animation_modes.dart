enum AnimationMode { fadeIn, typer, typeWriter }

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
