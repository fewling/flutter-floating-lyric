import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_state.dart';

final mainStateProvider =
    NotifierProvider<MainStateNotifier, MainState>(MainStateNotifier.new);

class MainStateNotifier extends Notifier<MainState> {
  @override
  MainState build() => const MainState();

  void updateScreenIndex(int index) =>
      state = state.copyWith(screenIndex: index);
}
