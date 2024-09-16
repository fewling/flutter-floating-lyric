import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../v4/configs/routes/app_router.dart';
import '../domain/base_drawer_routes.dart';

part 'base_notifier.g.dart';

@riverpod
class BaseNotifier extends _$BaseNotifier {
  @override
  void build() {}

  void onNavDrawerDestinationSelected(int index) {
    final route = BaseDrawerRoutes.values[index];
    ref.read(appRouterProvider).goNamed(route.name);
  }
}
