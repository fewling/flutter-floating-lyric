part of 'app_router.dart';

enum MainAppRoutes {
  onboarding('/onboarding'),

  home('/'),
  fonts('fonts'),

  localLyrics('/local-lyric'),
  localLyricDetail(':id'),

  settings('/settings');

  const MainAppRoutes(this.path);

  final String path;
}
