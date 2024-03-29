import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../screens/base/presentation/base_screen.dart';
import '../../screens/home/presentation/home_screen.dart';
import '../../screens/lyric_detail/presentation/lyric_detail_screen.dart';
import '../../screens/lyric_list/presentation/lyric_list_screen.dart';
import '../../screens/permission/permission_screen.dart';
import '../../screens/settings/presentation/settings_screen.dart';
import '../../services/permission_provider.dart';
import 'app_routes.dart';
import 'app_routes_observer.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final rootKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();

  final allGranted = ValueNotifier(false);
  ref.listen(permissionStateProvider, (_, next) {
    allGranted.value =
        next.isSystemAlertWindowGranted && next.isNotificationListenerGranted;
  });

  final router = GoRouter(
    navigatorKey: rootKey,
    refreshListenable: allGranted,
    initialLocation: AppRoute.home.path,
    observers: [AppRouteObserver()],
    redirect: (context, state) {
      if (!allGranted.value) return AppRoute.permission.path;

      final inPermissionPg = state.matchedLocation == AppRoute.permission.path;
      if (inPermissionPg) return AppRoute.home.path;

      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: rootKey,
        path: AppRoute.permission.path,
        name: AppRoute.permission.name,
        builder: (context, state) => const PermissionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: AppRoute.localLyricDetail.path,
        name: AppRoute.localLyricDetail.name,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          // TODO: show error page
          if (id == null) return const SizedBox.shrink();
          return LyricDetailScreen(id: id);
        },
      ),
      ShellRoute(
        navigatorKey: shellKey,
        parentNavigatorKey: rootKey,
        builder: (_, __, child) => BaseScreen(child: child),
        routes: [
          GoRoute(
            parentNavigatorKey: shellKey,
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            parentNavigatorKey: shellKey,
            path: AppRoute.localLyrics.path,
            name: AppRoute.localLyrics.name,
            builder: (context, state) => const LyricListScreen(),
          ),
          GoRoute(
            parentNavigatorKey: shellKey,
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    allGranted.dispose();
    router.dispose();
  });

  return router;
}
