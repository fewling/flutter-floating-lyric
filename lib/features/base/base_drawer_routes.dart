part of 'base_shell.dart';

enum BaseDrawerRoutes {
  home(
    route: AppRoute.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  localLyrics(
    route: AppRoute.localLyrics,
    label: 'Stored Lyrics',
    icon: Icons.audio_file_outlined,
    selectedIcon: Icons.audio_file,
  ),
  settings(
    route: AppRoute.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  );

  const BaseDrawerRoutes({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final AppRoute route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
