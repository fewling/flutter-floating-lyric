enum AppRoute {
  home(path: '/'),
  localLyrics(path: '/local-lyric'),
  localLyricDetail(path: '/local-lyric-detail/:id'),
  settings(path: '/settings'),
  permission(path: '/permission');

  const AppRoute({
    required this.path,
  });

  final String path;
}
