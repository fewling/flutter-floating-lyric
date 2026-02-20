import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/app_router.dart';
import '../../utils/extensions/custom_extensions.dart';

part 'base_drawer_routes.dart';

class BaseShell extends StatelessWidget {
  const BaseShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fullPath = GoRouterState.of(context).fullPath;

    final index = BaseDrawerRoutes.values.indexWhere(
      (drawerRoute) => drawerRoute.route.path == fullPath,
    );

    return Scaffold(
      // appBar: title == null ? null : AppBar(title: Text(title)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index > -1 ? index : 0,
        onDestinationSelected: (index) {
          final route = BaseDrawerRoutes.values[index];
          context.goNamed(route.route.name);
        },
        destinations: [
          for (final route in BaseDrawerRoutes.values)
            NavigationDestination(
              label: route.label(context),
              icon: Icon(route.icon),
              selectedIcon: Icon(route.selectedIcon),
            ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}
