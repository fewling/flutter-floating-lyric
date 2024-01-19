import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/routing/app_router.dart';
import '../../../utils/routing/app_routes.dart';

part 'base_notifier.g.dart';

@riverpod
class BaseNotifier extends _$BaseNotifier {
  @override
  void build() {}

  void onNavDrawerDestinationSelected(int index) {
    final route = AppRoute.values[index];
    ref.read(appRouterProvider).goNamed(route.name);
  }
}
