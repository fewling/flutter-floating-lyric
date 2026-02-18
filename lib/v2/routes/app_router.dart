import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../blocs/permission/permission_bloc.dart';
import '../pages/home/page.dart';
import '../pages/onboarding/page.dart';
import '../shells/base/shell.dart';

part 'app_route_params.dart';
part 'app_router_refresh_stream.dart';
part 'main_app_routes.dart';
part 'overlay_app_routes.dart';

class AppRouter {
  AppRouter.standard({required PermissionBloc permissionBloc}) {
    _router = GoRouter(
      refreshListenable: _GoRouterRefreshStream([permissionBloc.stream]),
      redirect: (context, state) {
        final currentRoute = MainAppRoutes.values.firstWhereOrNull(
          (route) => state.topRoute?.name == route.name,
        );

        final permissionState = permissionBloc.state;
        final allGranted =
            permissionState.isSystemAlertWindowGranted &&
            permissionState.isNotificationListenerGranted;
        if (!allGranted) return MainAppRoutes.onboarding.path;

        switch (currentRoute) {
          case MainAppRoutes.onboarding:
            return MainAppRoutes.home.path;
          case null:
          case MainAppRoutes.home:
          case MainAppRoutes.fonts:
          case MainAppRoutes.localLyrics:
          case MainAppRoutes.localLyricDetail:
          case MainAppRoutes.settings:
            break;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: MainAppRoutes.onboarding.path,
          name: MainAppRoutes.onboarding.name,
          builder: (context, state) => const OnboardingPage(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              BaseShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.home.path,
                  name: MainAppRoutes.home.name,
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.localLyrics.path,
                  name: MainAppRoutes.localLyrics.name,
                  builder: (context, state) => const Placeholder(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.settings.path,
                  name: MainAppRoutes.settings.name,
                  builder: (context, state) => const Placeholder(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  AppRouter.overlay() {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: OverlayAppRoutes.root.path,
          name: OverlayAppRoutes.root.name,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    );
  }

  late final GoRouter _router;

  GoRouter get router => _router;
}
