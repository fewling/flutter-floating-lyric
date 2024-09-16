import 'package:flutter/material.dart';

import '../../../v4/configs/routes/app_router.dart';

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
