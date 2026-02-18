import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../blocs/permission/permission_bloc.dart';
import '../pages/home/page.dart';
import '../pages/onboarding/page.dart';

part 'app_route_params.dart';
part 'app_router_refresh_stream.dart';
part 'app_routes.dart';

class AppRouter {
  AppRouter.standard({required PermissionBloc permissionBloc}) {
    _router = GoRouter(
      refreshListenable: _GoRouterRefreshStream([permissionBloc.stream]),
      redirect: (context, state) {
        final currentRoute = AppRoutes.values.firstWhereOrNull(
          (route) => state.topRoute?.name == route.name,
        );

        print('>>> currentRoute: $currentRoute');

        final permissionState = permissionBloc.state;
        final allGranted =
            permissionState.isSystemAlertWindowGranted &&
            permissionState.isNotificationListenerGranted;
        print('>>> allGranted: $allGranted');
        if (!allGranted) return AppRoutes.onboarding.path;

        switch (currentRoute) {
          case null:
          case AppRoutes.home:
            break;
          case AppRoutes.onboarding:
            return AppRoutes.home.path;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.onboarding.path,
          name: AppRoutes.onboarding.name,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }

  AppRouter.overlay() {
    _router = GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          builder: (context, state) => const OnboardingPage(),
        ),
      ],
    );
  }

  late final GoRouter _router;

  GoRouter get router => _router;
}
