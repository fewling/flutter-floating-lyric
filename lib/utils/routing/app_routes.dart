enum AppRoute {
  home(path: '/'),
  localLyrics(path: '/local-lyric'),
  localLyricDetail(path: '/local-lyric-detail'),
  settings(path: '/settings'),
  bugReport(path: '/bug-report'),
  permission(path: '/permission');

  const AppRoute({
    required this.path,
  });

  final String path;
}
