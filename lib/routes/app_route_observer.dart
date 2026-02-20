part of 'app_router.dart';

class _AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t('➕ AppRouteObserver.didPush, route.name: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t('➖ AppRouteObserver.didPop, route.name: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.t(
      '❌ AppRouteObserver.didRemove, route.name: ${route.settings.name}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.t(
      '🔃 AppRouteObserver.didReplace, route.name: ${oldRoute?.settings.name} ==> ${newRoute?.settings.name}',
    );
  }
}
