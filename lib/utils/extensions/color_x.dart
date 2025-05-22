part of 'custom_extensions.dart';

extension ColorX on Color {
  /// Returns a new color with the same RGB values but with the specified alpha value.
  /// The alpha value should be between 0 and 255.
  Color withTransparency(double transparency) {
    assert(
      transparency >= 0 && transparency <= 1,
      'Transparency must be between 0 and 1',
    );

    return withAlpha((transparency * 255).toInt());
  }
}
