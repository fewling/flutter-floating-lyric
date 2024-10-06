part of 'app_router.dart';

enum AppRoute {
  home(path: '/'),
  fonts(path: 'fonts'),

  localLyrics(path: '/local-lyric'),
  localLyricDetail(path: ':id'),

  settings(path: '/settings'),

  permission(path: '/permission'),
  ;

  const AppRoute({
    required this.path,
  });

  final String path;
}
