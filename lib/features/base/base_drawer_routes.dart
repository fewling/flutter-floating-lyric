part of 'base_shell.dart';

enum BaseDrawerRoutes {
  home(
    route: AppRoute.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  localLyrics(
    route: AppRoute.localLyrics,
    icon: Icons.audio_file_outlined,
    selectedIcon: Icons.audio_file,
  ),
  settings(
    route: AppRoute.settings,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  );

  const BaseDrawerRoutes({
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final AppRoute route;
  final IconData icon;
  final IconData selectedIcon;

  String label(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case BaseDrawerRoutes.home:
        return l10n.home;
      case BaseDrawerRoutes.localLyrics:
        return l10n.storedLyrics;
      case BaseDrawerRoutes.settings:
        return l10n.settings;
    }
  }
}
