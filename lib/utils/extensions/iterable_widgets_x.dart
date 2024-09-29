part of 'custom_extensions.dart';

extension IterableWidgetsX on Iterable<Widget> {
  Iterable<Widget> separatedBy(Widget separator) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;

    yield iterator.current;

    while (iterator.moveNext()) {
      yield separator;
      yield iterator.current;
    }
  }
}
