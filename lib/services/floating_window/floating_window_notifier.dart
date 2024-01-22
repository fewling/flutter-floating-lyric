import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'floating_window_state.dart';

part 'floating_window_notifier.g.dart';

@Riverpod(keepAlive: true)
class FloatingWindowNotifier extends _$FloatingWindowNotifier {
  @override
  FloatingWindowState build() {
    return const FloatingWindowState(
      isVisible: false,
    );
  }
}
