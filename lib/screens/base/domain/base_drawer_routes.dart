import 'package:flutter/material.dart';

import '../../../utils/routing/app_routes.dart';

enum BaseDrawerRoutes {
  home(
    route: AppRoute.home,
    label: 'Home',
    icon: Icons.home_outlined,
  ),
  localLyrics(
    route: AppRoute.localLyrics,
    label: 'Local Lyrics',
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
