import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../v4/features/device_info/device_info_listener.dart';
import '../../../v4/features/lyric_state_listener/lyric_state_listener.dart';
import '../../../v4/features/overlay_window/bloc/overlay_window_bloc.dart';
import '../../../v4/features/preference/bloc/preference_bloc.dart';
import '../../../v4/service/overlay_window/overlay_window_service.dart';
import '../domain/base_drawer_routes.dart';
import 'base_notifier.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
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
        drawer: Consumer(
          builder: (context, ref, _) => NavigationDrawer(
            selectedIndex: index > -1 ? index : null,
            children: [
              for (final route in BaseDrawerRoutes.values)
                NavigationDrawerDestination(
                  icon: Icon(route.icon),
                  label: Text(route.label),
                ),
            ],
            onDestinationSelected: (index) {
              ref.read(baseNotifierProvider.notifier).onNavDrawerDestinationSelected(index);
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
