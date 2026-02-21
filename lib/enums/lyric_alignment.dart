enum LyricAlignment { left, center, right, alternating }

extension LyricAlignmentX on LyricAlignment {
  String get name {
    switch (this) {
      case LyricAlignment.left:
        return 'left';
      case LyricAlignment.center:
        return 'center';
      case LyricAlignment.right:
        return 'right';
      case LyricAlignment.alternating:
        return 'alternating';
    }
  }
}

LyricAlignment lyricAlignmentFromJson(String str) =>
    LyricAlignment.values.firstWhere(
      (alignment) => alignment.name == str,
      orElse: () => LyricAlignment.center,
    );

String lyricAlignmentToJson(LyricAlignment alignment) => alignment.name;
