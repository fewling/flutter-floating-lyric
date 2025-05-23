// ignore_for_file: strict_raw_type

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/base/base_shell.dart';
import '../../features/font_select/bloc/font_select_bloc.dart';
import '../../features/font_select/font_select.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/home/home_screen.dart';
import '../../features/lyric_list/bloc/lyric_list_bloc.dart';
import '../../features/lyric_list/lyric_detail/bloc/lyric_detail_bloc.dart';
import '../../features/lyric_list/lyric_detail/lyric_detail_screen.dart';
import '../../features/lyric_list/lyric_list_screen.dart';
import '../../features/lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../../features/permissions/bloc/permission_bloc.dart';
import '../../features/permissions/permission_screen.dart';
import '../../features/settings/bloc/settings_bloc.dart';
import '../../features/settings/settings_screen.dart';
import '../../repos/local/local_db_repo.dart';
import '../../service/db/local/local_db_service.dart';
import '../../service/lrc/lrc_process_service.dart';
import 'app_routes_observer.dart';

part 'app_routes.dart';

class AppRouter {
  AppRouter({required this.permissionBloc}) {
    _router = GoRouter(
      navigatorKey: _rootKey,
      refreshListenable: StreamToListenable([permissionBloc.stream]),
      initialLocation: AppRoute.permission.path,
      observers: [AppRouteObserver()],
      redirect: (context, state) {
        final permissionState = permissionBloc.state;
        final allGranted =
            permissionState.isSystemAlertWindowGranted &&
            permissionState.isNotificationListenerGranted;
        if (!allGranted) return AppRoute.permission.path;

        final inPermissionPg =
            state.matchedLocation == AppRoute.permission.path;
        if (inPermissionPg) return AppRoute.home.path;

        return null;
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _rootKey,
          path: AppRoute.permission.path,
          name: AppRoute.permission.name,
          builder: (context, state) => const PermissionScreen(),
        ),
        ShellRoute(
          navigatorKey: _shellKey,
          parentNavigatorKey: _rootKey,
          builder: (_, __, child) => BaseShell(child: child),
          routes: [
            GoRoute(
              parentNavigatorKey: _shellKey,
              path: AppRoute.home.path,
              name: AppRoute.home.name,
              builder: (context, state) => BlocProvider(
                create: (context) => HomeBloc()
                  ..add(
                    HomeStarted(
                      mediaState: context
                          .read<LyricStateListenerBloc>()
                          .state
                          .mediaState,
                    ),
                  ),
                child: const HomeScreen(),
              ),
              routes: [
                GoRoute(
                  path: AppRoute.fonts.path,
                  name: AppRoute.fonts.name,
                  builder: (context, state) => BlocProvider(
                    create: (context) =>
                        FontSelectBloc()..add(const FontSelectStarted()),
                    child: const FontSelect(),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: _shellKey,
              path: AppRoute.localLyrics.path,
              name: AppRoute.localLyrics.name,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LyricListBloc(
                      localDbService: LocalDbService(
                        localDBRepo: context.read<LocalDbRepo>(),
                      ),
                      lrcProcessorService: LrcProcessorService(
                        localDB: context.read<LocalDbRepo>(),
                      ),
                    )..add(const LyricListLoaded()),
                  ),
                ],
                child: const LyricListScreen(),
              ),
              routes: [
                GoRoute(
                  path: AppRoute.localLyricDetail.path,
                  name: AppRoute.localLyricDetail.name,
                  builder: (context, state) {
                    final id = state.pathParameters['id'];
                    return BlocProvider(
                      create: (context) => LyricDetailBloc(
                        localDbService: LocalDbService(
                          localDBRepo: context.read<LocalDbRepo>(),
                        ),
                      )..add(LyricDetailLoaded(id: id)),
                      child: const LyricDetailScreen(),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: _shellKey,
              path: AppRoute.settings.path,
              name: AppRoute.settings.name,
              builder: (context, state) => BlocProvider(
                create: (context) => SettingsBloc(),
                child: const SettingsScreen(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();

  final PermissionBloc permissionBloc;

  late GoRouter _router;

  GoRouter get router => _router;
}

class StreamToListenable extends ChangeNotifier {
  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (final e in streams) {
      final s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }
  late final List<StreamSubscription> subscriptions;

  @override
  void dispose() {
    for (final e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
