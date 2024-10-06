import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/routes/app_router.dart';
import '../device_info/device_info_listener.dart';
import '../preference/bloc/preference_bloc.dart';

part 'base_drawer_routes.dart';

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

    final fontFamily = context.select((PreferenceBloc bloc) => bloc.state.fontFamily);

    return DefaultTextStyle(
      style: GoogleFonts.getFont(fontFamily),
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
          child: child,
        ),
      ),
    );
  }
}
