enum FloatingOverlayStateTypes {
  lyricState(value: 'LYRIC_STATE'),
  styleState(value: 'STYLE_STATE'),
  ;

  const FloatingOverlayStateTypes({
    required this.value,
  });
  final String value;
}
