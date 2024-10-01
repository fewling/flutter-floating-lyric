import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/app_router.dart';
import '../../service/overlay_window/overlay_window_service.dart';
import '../device_info/device_info_listener.dart';
import '../lyric_state_listener/lyric_state_listener.dart';
import '../overlay_window/bloc/overlay_window_bloc.dart';
import '../preference/bloc/preference_bloc.dart';

class BaseShell extends StatelessWidget {
  const BaseShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fullPath = GoRouterState.of(context).fullPath;

    final index = BaseDrawerRoutes.values.indexWhere((drawerRoute) => drawerRoute.route.path == fullPath);
    final title = index > -1 ? BaseDrawerRoutes.values[index].label : 'Home';

    final ratio = MediaQuery.of(context).devicePixelRatio;
    final pref = context.watch<PreferenceBloc>().state;

    return BlocProvider(
      create: (context) {
        return OverlayWindowBloc(
          overlayWindowService: OverlayWindowService(),
          devicePixelRatio: ratio,
        )..add(OverlayWindowLoaded(
            opacity: pref.opacity,
            color: pref.color,
            fontSize: pref.fontSize,
            showProgressBar: pref.showProgressBar,
            showMillis: pref.showMilliseconds,
          ));
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Builder(
          builder: (context) => NavigationDrawer(
            selectedIndex: index > -1 ? index : null,
            children: [
              for (final route in BaseDrawerRoutes.values)
                NavigationDrawerDestination(
                  icon: Icon(route.icon),
                  label: Text(route.label),
                ),
            ],
            onDestinationSelected: (index) {
              final route = BaseDrawerRoutes.values[index];
              context.goNamed(route.name);
              Scaffold.of(context).closeDrawer();
            },
          ),
        ),
        body: DeviceInfoListener(
          child: LyricStateListener(
            child: child,
          ),
        ),
      ),
    );
  }
}

enum BaseDrawerRoutes {
  home(
    route: AppRoute.home,
    label: 'Home',
    icon: Icons.home_outlined,
  ),
  localLyrics(
    route: AppRoute.localLyrics,
    label: 'Stored Lyrics',
    icon: Icons.audio_file_outlined,
  ),
  settings(
    route: AppRoute.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
  );

  const BaseDrawerRoutes({
    required this.route,
    required this.label,
    required this.icon,
  });

  final AppRoute route;
  final String label;
  final IconData icon;
}
