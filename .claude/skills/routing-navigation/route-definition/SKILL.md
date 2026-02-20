---
name: route-definition
description: Defining routes with GoRouter and freezed path parameters in the Floating Lyric app. Covers route configuration, navigation, deep linking, and route guards. Use this when adding new routes or modifying navigation.
license: MIT
---

# Route Definition

This skill documents how to define and configure routes using GoRouter with freezed path parameters in the Floating Lyric app.

## Router Structure

The app's router is organized across multiple files:

```
lib/routes/
├── app_router.dart              # Main router configuration
├── app_route_observer.dart      # Route observation (analytics, logging)
├── app_router_refresh_stream.dart  # Stream-based refresh for guards
├── main_app_routes.dart         # Main app route definitions
├── main_route_path_params.dart  # Freezed path parameters
├── overlay_app_routes.dart      # Overlay app route definitions
├── app_router.freezed.dart      # Generated
└── app_router.g.dart            # Generated
```

## Route Definition Pattern

### 1. Define Route Enum

Create enum in `main_app_routes.dart`:

```dart
part of 'app_router.dart';

enum MainAppRoutes {
  onboarding('/onboarding'),
  home('/'),
  fonts('fonts'),                    // Relative path (child route)
  localLyrics('/local-lyric'),
  localLyricDetail(':id'),           // Path parameter
  settings('/settings');

  const MainAppRoutes(this.path);

  final String path;
}
```

**Key Points**:

- Use `part of 'app_router.dart'`
- Routes starting with `/` are absolute
- Routes without `/` are relative (child routes)
- Use `:paramName` for path parameters
- Store path as a final field

### 2. Define Path Parameters (if needed)

For routes with parameters, create freezed classes in `main_route_path_params.dart`:

```dart
part of 'app_router.dart';

@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.localLyricDetail({
    required String id,
  }) = LocalLyricDetailPathParams;

  factory MainRoutePathParams.fromJson(Map<String, dynamic> json) =>
      _$MainRoutePathParamsFromJson(json);
}

extension MainRoutePathParamsX on MainRoutePathParams {
  Map<String, String> toPathJson() {
    final json = toJson()..remove('runtimeType');
    return json.map((key, value) => MapEntry(key, '$value'));
  }
}
```

**Key Points**:

- Use `@freezed` for type-safe parameters
- Use `sealed class` for union types
- Add `toPathJson()` extension for navigation
- Each route variant corresponds to a route with parameters

### 3. Register Routes in GoRouter

In `app_router.dart`:

```dart
class AppRouter {
  AppRouter.standard({required PermissionBloc permissionBloc}) {
    _router = GoRouter(
      observers: [_AppRouteObserver()],
      refreshListenable: _GoRouterRefreshStream([permissionBloc.stream]),
      redirect: (context, state) {
        // Route guards (see Route Guards section)
        final permissionState = permissionBloc.state;
        final allGranted = permissionState.isSystemAlertWindowGranted &&
            permissionState.isNotificationListenerGranted;
        if (!allGranted) return MainAppRoutes.onboarding.path;

        return null;
      },
      routes: [
        // Simple route
        GoRoute(
          path: MainAppRoutes.onboarding.path,
          name: MainAppRoutes.onboarding.name,
          builder: (context, state) => const OnboardingPage(),
        ),

        // Routes with shell (bottom navigation)
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              BaseShell(navigationShell: navigationShell),
          branches: [
            // Home branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.home.path,
                  name: MainAppRoutes.home.name,
                  builder: (context, state) => const HomePage(),
                  routes: [
                    // Child route (relative path)
                    GoRoute(
                      path: MainAppRoutes.fonts.path,
                      name: MainAppRoutes.fonts.name,
                      builder: (context, state) => const FontsPage(),
                    ),
                  ],
                ),
              ],
            ),

            // Local lyrics branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.localLyrics.path,
                  name: MainAppRoutes.localLyrics.name,
                  builder: (context, state) => const LocalLyricsPage(),
                  routes: [
                    // Route with path parameter
                    GoRoute(
                      path: MainAppRoutes.localLyricDetail.path,
                      name: MainAppRoutes.localLyricDetail.name,
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return LocalLyricDetailPage(id: id);
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Settings branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: MainAppRoutes.settings.path,
                  name: MainAppRoutes.settings.name,
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  late final GoRouter _router;
  GoRouter get router => _router;
}
```

## Navigation Patterns

### 1. Navigate to Simple Route

```dart
// Using path
context.go('/settings');

// Using enum
context.go(MainAppRoutes.settings.path);

// Using named route
context.goNamed(MainAppRoutes.settings.name);
```

### 2. Navigate with Path Parameters

```dart
// Manual parameter injection
context.go('/local-lyric/123');

// Type-safe with freezed
final params = MainRoutePathParams.localLyricDetail(id: '123');
context.goNamed(
  MainAppRoutes.localLyricDetail.name,
  pathParameters: params.toPathJson(),
);
```

### 3. Navigate to Child Route

```dart
// Relative child route
context.go('/fonts');  // From home page

// Or use full path
context.go('/${MainAppRoutes.home.path}/${MainAppRoutes.fonts.path}');
```

### 4. Pop/Back Navigation

```dart
// Go back
context.pop();

// Pop with result
context.pop(result);

// Check if can pop
if (context.canPop()) {
  context.pop();
} else {
  context.go('/');
}
```

### 5. Replace Current Route

```dart
// Replace instead of push
context.pushReplacement('/new-route');

// Replace named route
context.pushReplacementNamed(MainAppRoutes.home.name);
```

## StatefulShellRoute (Bottom Navigation)

For persistent bottom navigation bar:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      BaseShell(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: MainAppRoutes.home.path,
          name: MainAppRoutes.home.name,
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: MainAppRoutes.localLyrics.path,
          name: MainAppRoutes.localLyrics.name,
          builder: (context, state) => const LocalLyricsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: MainAppRoutes.settings.path,
          name: MainAppRoutes.settings.name,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
)
```

**Features**:

- Maintains state across tab switches
- Uses `IndexedStack` under the hood
- Each branch is a separate navigation stack

### BaseShell Implementation

```dart
class BaseShell extends StatelessWidget {
  const BaseShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Lyrics'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
```

## Route Guards (Redirect)

Use `redirect` for authentication/permission checks:

```dart
GoRouter(
  redirect: (context, state) {
    final currentRoute = MainAppRoutes.values.firstWhereOrNull(
      (route) => state.topRoute?.name == route.name,
    );

    // Check permissions
    final permissionState = permissionBloc.state;
    final allGranted = permissionState.isSystemAlertWindowGranted &&
        permissionState.isNotificationListenerGranted;

    // Redirect to onboarding if permissions not granted
    if (!allGranted) return MainAppRoutes.onboarding.path;

    // Don't redirect onboarding if already granted
    if (currentRoute == MainAppRoutes.onboarding) {
      return MainAppRoutes.home.path;
    }

    // Allow navigation
    return null;  // null means no redirect
  },
  routes: [...],
)
```

**Key Points**:

- Return `null` to allow navigation
- Return a path string to redirect
- Runs on every navigation
- Use `refreshListenable` to re-run when state changes

## Refresh on State Changes

To re-evaluate route guards when BLoC state changes:

```dart
GoRouter(
  refreshListenable: _GoRouterRefreshStream([permissionBloc.stream]),
  redirect: (context, state) {
    // This runs whenever permissionBloc.stream emits
    // ...
  },
  routes: [...],
)
```

### GoRouterRefreshStream Implementation

```dart
part of 'app_router.dart';

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      stream.listen((_) => notifyListeners());
    }
  }
}
```

## Route Observation

Track route changes for analytics or logging:

```dart
part of 'app_router.dart';

class _AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    logger.i('Pushed route: ${route.settings.name}');
    // Send analytics event
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    logger.i('Popped route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    logger.i('Replaced route: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
```

Register observer:

```dart
GoRouter(
  observers: [_AppRouteObserver()],
  routes: [...],
)
```

## Adding a New Route

### Step-by-Step Guide

1. **Add route to enum** (`main_app_routes.dart`):

   ```dart
   enum MainAppRoutes {
     // ...
     newRoute('/new-route'),
     newRouteDetail(':id'),  // If has parameters
   }
   ```

2. **Add path parameters** if needed (`main_route_path_params.dart`):

   ```dart
   @freezed
   sealed class MainRoutePathParams with _$MainRoutePathParams {
     // ...
     const factory MainRoutePathParams.newRouteDetail({
       required String id,
     }) = NewRouteDetailPathParams;
   }
   ```

3. **Generate code**:

   ```bash
   fvm flutter pub run build_runner build -d
   ```

4. **Register route** (`app_router.dart`):

   ```dart
   GoRoute(
     path: MainAppRoutes.newRoute.path,
     name: MainAppRoutes.newRoute.name,
     builder: (context, state) => const NewRoutePage(),
     routes: [
       GoRoute(
         path: MainAppRoutes.newRouteDetail.path,
         name: MainAppRoutes.newRouteDetail.name,
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return NewRouteDetailPage(id: id);
         },
       ),
     ],
   ),
   ```

5. **Navigate to route**:

   ```dart
   context.goNamed(MainAppRoutes.newRoute.name);

   // Or with parameters
   final params = MainRoutePathParams.newRouteDetail(id: '123');
   context.goNamed(
     MainAppRoutes.newRouteDetail.name,
     pathParameters: params.toPathJson(),
   );
   ```

## Query Parameters

For optional parameters, use query parameters:

```dart
// Navigate with query params
context.goNamed(
  MainAppRoutes.localLyrics.name,
  queryParameters: {'search': 'query', 'filter': 'all'},
);

// Access in page
class LocalLyricsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final search = state.uri.queryParameters['search'];
    final filter = state.uri.queryParameters['filter'];
    // ...
  }
}

// Or in builder
GoRoute(
  path: MainAppRoutes.localLyrics.path,
  name: MainAppRoutes.localLyrics.name,
  builder: (context, state) {
    final search = state.uri.queryParameters['search'];
    return LocalLyricsPage(initialSearch: search);
  },
)
```

## Deep Linking

GoRouter automatically handles deep links if configured:

### Android (`AndroidManifest.xml`):

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="floatinglyric.app" />
</intent-filter>
```

### iOS (`Info.plist`):

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>floatinglyric</string>
        </array>
    </dict>
</array>
```

Then routes are automatically matched:

- `https://floatinglyric.app/settings` → Settings page
- `floatinglyric://local-lyric/123` → Lyric detail page

## Best Practices

### DO

✅ **Use enums for route definitions** (type safety)  
✅ **Use freezed for path parameters** (type safety)  
✅ **Use named routes** for navigation (refactoring-friendly)  
✅ **Implement route guards** for permissions/auth  
✅ **Use StatefulShellRoute** for persistent navigation  
✅ **Add route observers** for analytics  
✅ **Handle null safety** in path parameters

### DON'T

❌ **Don't use hard-coded strings** for navigation  
❌ **Don't forget to generate code** after adding routes  
❌ **Don't skip null checks** on path parameters  
❌ **Don't use context.go** in async gaps (check mounted)  
❌ **Don't create circular redirects** in route guards  
❌ **Don't forget to handle back button** on root routes

## Common Patterns

### 1. Modal Bottom Sheet Route

```dart
GoRoute(
  path: '/modal',
  name: 'modal',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: const ModalPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  },
)
```

### 2. Conditional Route

```dart
redirect: (context, state) {
  if (condition) {
    return '/alternative-route';
  }
  return null;
}
```

### 3. Route with Extra Data

```dart
// Navigate with extra data
context.goNamed(
  MainAppRoutes.detail.name,
  extra: {'user': user, 'settings': settings},
);

// Access in builder
builder: (context, state) {
  final extra = state.extra as Map<String, dynamic>;
  final user = extra['user'] as User;
  return DetailPage(user: user);
}
```

## Related Skills

- [Page Architecture](../../architecture/page-architecture/SKILL.md) - Page structure
- [Code Conventions](../../development/code-conventions/SKILL.md) - File naming
- [Freezed Models](../../code-generation/freezed-models/SKILL.md) - Path parameters
- [Build Commands](../../code-generation/build-commands/SKILL.md) - Generating routes
