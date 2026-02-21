import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_router.dart';
import '../../../../utils/extensions/custom_extensions.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(
        builder: (context) => _View(navigationShell: navigationShell),
      ),
    );
  }
}
