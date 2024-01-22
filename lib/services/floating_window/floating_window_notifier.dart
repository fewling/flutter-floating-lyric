import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../event_channels/window_states/window_state.dart';
import '../event_channels/window_states/window_state_event_channel.dart';

part 'floating_window_notifier.g.dart';

@Riverpod(keepAlive: true)
class FloatingWindowNotifier extends _$FloatingWindowNotifier {
  @override
  WindowState build() {
    windowStateStream.listen((event) => state = event);
    return const WindowState();
  }
}
