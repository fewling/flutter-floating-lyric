part of 'app_router.dart';

enum AppRoutes {
  home('/'),
  onboarding('/onboarding');

  const AppRoutes(this.path);
  final String path;
}
