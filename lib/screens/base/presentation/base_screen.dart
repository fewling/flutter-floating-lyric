import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/routing/app_routes.dart';
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

    final index = AppRoute.values.indexWhere((route) => route.path == fullPath);
    final title = index > -1 ? AppRoute.values[index].name : 'Home';

    return Scaffold(
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
            ref
                .read(baseNotifierProvider.notifier)
                .onNavDrawerDestinationSelected(index);
            Scaffold.of(context).closeDrawer();
          },
        ),
      ),
      body: child,
    );
  }
}
