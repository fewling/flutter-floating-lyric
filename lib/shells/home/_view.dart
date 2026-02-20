part of 'shell.dart';

class _View extends StatelessWidget {
  const _View({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex >= 0
            ? navigationShell.currentIndex
            : 0,
        onDestinationSelected: (index) =>
            context.goNamed(NavBarItems.values.elementAt(index).route.name),
        destinations: [
          for (final route in NavBarItems.values)
            NavigationDestination(
              label: route.label(context),
              icon: Icon(route.icon),
              selectedIcon: Icon(route.selectedIcon),
            ),
        ],
      ),
    );
  }
}

enum NavBarItems {
  home(
    route: MainAppRoutes.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  localLyrics(
    route: MainAppRoutes.localLyrics,
    icon: Icons.audio_file_outlined,
    selectedIcon: Icons.audio_file,
  ),
  settings(
    route: MainAppRoutes.settings,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  );

  const NavBarItems({
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final MainAppRoutes route;
  final IconData icon;
  final IconData selectedIcon;

  String label(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case NavBarItems.home:
        return l10n.home;
      case NavBarItems.localLyrics:
        return l10n.storedLyrics;
      case NavBarItems.settings:
        return l10n.settings;
    }
  }
}
