import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

import '../apps/main/main_app.dart';
import '../apps/main/pages/fonts/page.dart';
import '../apps/main/pages/home/page.dart';
import '../apps/main/pages/local_lyric_detail/page.dart';
import '../apps/main/pages/local_lyrics/page.dart';
import '../apps/main/pages/onboarding/page.dart';
import '../apps/main/pages/settings/page.dart';
import '../apps/main/shells/home/shell.dart';
import '../apps/overlay/pages/lyrics/page.dart';
import '../apps/overlay/shells/overlay/shell.dart';
import '../blocs/permission/permission_bloc.dart';
import '../utils/logger.dart';

part 'app_route_observer.dart';
part 'app_router.freezed.dart';
part 'app_router.g.dart';
part 'app_router_refresh_stream.dart';
part 'main_app_routes.dart';
part 'main_route_path_params.dart';
part 'overlay_app_routes.dart';

class AppRouter {
  AppRouter.standard({required PermissionBloc permissionBloc}) {
    _router = GoRouter(
      observers: [_AppRouteObserver()],
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
        ShellRoute(
          builder: (context, state, child) =>
              MainAppListener(builder: (context) => child),
          routes: [
            GoRoute(
              path: MainAppRoutes.onboarding.path,
              name: MainAppRoutes.onboarding.name,
              builder: (context, state) => const OnboardingPage(),
            ),
            StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) =>
                  HomeShell(navigationShell: navigationShell),
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: MainAppRoutes.home.path,
                      name: MainAppRoutes.home.name,
                      builder: (context, state) => const HomePage(),
                      routes: [
                        GoRoute(
                          path: MainAppRoutes.fonts.path,
                          name: MainAppRoutes.fonts.name,
                          builder: (context, state) => const FontsPage(),
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: MainAppRoutes.localLyrics.path,
                      name: MainAppRoutes.localLyrics.name,
                      builder: (context, state) => const LocalLyricsPage(),
                      routes: [
                        GoRoute(
                          path: MainAppRoutes.localLyricDetail.path,
                          name: MainAppRoutes.localLyricDetail.name,
                          builder: (context, state) => LocalLyricDetailPage(
                            pathParams: LocalLyricDetailPathParams.fromJson(
                              state.pathParameters,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: MainAppRoutes.settings.path,
                      name: MainAppRoutes.settings.name,
                      builder: (context, state) => const SettingsPage(),
                    ),
                  ],
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
      observers: [_AppRouteObserver()],
      routes: [
        ShellRoute(
          builder: (context, state, child) => OverlayShell(child: child),
          routes: [
            GoRoute(
              path: OverlayAppRoutes.lyrics.path,
              name: OverlayAppRoutes.lyrics.name,
              builder: (context, state) => const LyricsPage(),
            ),
          ],
        ),
      ],
    );
  }

  late final GoRouter _router;

  GoRouter get router => _router;
}
