---
name: routing-navigation
description: Routing and navigation overview using GoRouter in the Floating Lyric app. Covers route definition, navigation patterns, route guards, deep links, and dual-app routing. Use this as an entry point to understanding navigation in the app.
license: MIT
---

# Routing & Navigation

This skill provides an overview of routing and navigation in the Floating Lyric app using GoRouter with freezed path parameters.

## Overview

The Floating Lyric app uses **go_router** (v16.2.4) for declarative routing and deep linking support.

**Package**: `go_router: ^16.2.4`

## Why GoRouter?

### Advantages

✅ **Declarative routing** - Define all routes in one place  
✅ **Type-safe navigation** - Using freezed for path parameters  
✅ **Deep linking** - Built-in support for URLs  
✅ **Nested navigation** - StatefulShellRoute for tabs  
✅ **Route guards** - Redirect and authentication logic  
✅ **Error handling** - Custom error pages  
✅ **State restoration** - Browser back button support

## Routing Architecture

### Dual-App Routing

The Floating Lyric app has **two independent apps** with separate routing:

```
┌──────────────────────────────────┐
│  Main App (lib/apps/main_app/)   │
│  • Home page                     │
│  • Local lyrics page             │
│  • Settings page                 │
│  • Lyric detail/editor pages     │
│  Routes: MainAppRoutes enum      │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│  Overlay App (system overlay)    │
│  • Floating lyrics display       │
│  • Minimal UI                    │
│  Routes: OverlayAppRoutes enum   │
└──────────────────────────────────┘
```

Each app has its own:

- `AppRouter` class
- Route enum
- Path parameters
- Navigation context

### Route Organization

```
lib/routes/
├── app_router.dart                  # GoRouter configuration
├── main_app_routes.dart             # MainAppRoutes enum
├── main_route_path_params.dart      # Freezed path params
└── overlay_app_routes.dart          # OverlayAppRoutes enum (if exists)
```

## Route Definition

### Route Enum Pattern

All routes are defined in an enum for type safety:

```dart
enum MainAppRoutes {
  home,
  localLyrics,
  settings,
  lyricDetail,
  lyricEditor,
  createLyric;
}
```

### Freezed Path Parameters

Type-safe route parameters using freezed:

```dart
@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.lyricDetail({
    required String id,
  }) = _LyricDetailPathParams;

  const factory MainRoutePathParams.lyricEditor({
    required String id,
  }) = _LyricEditorPathParams;
}
```

See [Route Definition](route-definition/SKILL.md) for detailed patterns.

## GoRouter Configuration

### Basic Router Setup

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: MainAppRoutes.home.path,
    routes: [
      // Simple route
      GoRoute(
        name: MainAppRoutes.home.name,
        path: MainAppRoutes.home.path,
        builder: (context, state) => const HomePage(),
      ),

      // Route with path parameters
      GoRoute(
        name: MainAppRoutes.lyricDetail.name,
        path: MainAppRoutes.lyricDetail.path,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return LyricDetailPage(id: id);
        },
      ),

      // Nested routes
      GoRoute(
        name: MainAppRoutes.lyricDetail.name,
        path: MainAppRoutes.lyricDetail.path,
        builder: (context, state) => LyricDetailPage(id: state.pathParameters['id']!),
        routes: [
          GoRoute(
            name: MainAppRoutes.lyricEditor.name,
            path: 'edit',  // Relative path: /lyric/:id/edit
            builder: (context, state) => LyricEditorPage(id: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}
```

### StatefulShellRoute (Bottom Navigation)

The main app uses `StatefulShellRoute.indexedStack` for persistent bottom navigation:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainAppShell(navigationShell: navigationShell);
  },
  branches: [
    // Branch 0: Home
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: MainAppRoutes.home.name,
          path: MainAppRoutes.home.path,
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),

    // Branch 1: Local Lyrics
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: MainAppRoutes.localLyrics.name,
          path: MainAppRoutes.localLyrics.path,
          builder: (context, state) => const LocalLyricsPage(),
          routes: [
            // Nested detail page
            GoRoute(
              name: MainAppRoutes.lyricDetail.name,
              path: 'detail/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return LyricDetailPage(id: id);
              },
            ),
          ],
        ),
      ],
    ),

    // Branch 2: Settings
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: MainAppRoutes.settings.name,
          path: MainAppRoutes.settings.path,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
)
```

**Key Points:**

- Each branch maintains its own navigation stack
- Switching tabs preserves page state
- `MainAppShell` wraps navigation with bottom bar

## Navigation Patterns

### 1. Navigate by Name

```dart
// Simple navigation
context.goNamed(MainAppRoutes.home.name);

// With path parameters
context.goNamed(
  MainAppRoutes.lyricDetail.name,
  pathParameters: {'id': '123'},
);

// With query parameters
context.goNamed(
  MainAppRoutes.localLyrics.name,
  queryParameters: {'filter': 'favorites'},
);

// With extra data (not in URL)
context.goNamed(
  MainAppRoutes.lyricEditor.name,
  pathParameters: {'id': '123'},
  extra: {'mode': 'create'},
);
```

### 2. Push (Stack Navigation)

```dart
// Push new page (can go back)
context.pushNamed(MainAppRoutes.lyricDetail.name, pathParameters: {'id': '123'});

// Push and get result
final result = await context.pushNamed<bool>(
  MainAppRoutes.lyricEditor.name,
  pathParameters: {'id': '123'},
);

if (result == true) {
  // Refresh list
}
```

### 3. Replace

```dart
// Replace current route
context.replaceNamed(MainAppRoutes.home.name);
```

### 4. Pop

```dart
// Go back
context.pop();

// Go back with result
context.pop(true);
```

### 5. Check if Can Pop

```dart
if (context.canPop()) {
  context.pop();
} else {
  context.goNamed(MainAppRoutes.home.name); // Fallback to home if can't pop
}
```

## Route Guards & Redirects

### Global Redirect

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = /* check auth */;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }

    if (isLoggedIn && isLoginRoute) {
      return '/';
    }

    return null; // No redirect
  },
  // ...
)
```

### Route-Specific Redirect

```dart
GoRoute(
  name: MainAppRoutes.settings.name,
  path: MainAppRoutes.settings.path,
  redirect: (context, state) {
    final hasPermission = /* check permission */;
    if (!hasPermission) {
      return MainAppRoutes.home.path;
    }
    return null;
  },
  builder: (context, state) => const SettingsPage(),
)
```

## Accessing Route Data

### Path Parameters

```dart
// In route builder
GoRoute(
  path: '/lyric/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return LyricDetailPage(id: id);
  },
)

// In widget (using GoRouterState.of)
final id = GoRouterState.of(context).pathParameters['id'];
```

### Query Parameters

```dart
// In route builder
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final filter = state.uri.queryParameters['filter'];
    return SearchPage(query: query, filter: filter);
  },
)
```

### Extra Data

```dart
// Pass extra data (not serialized in URL)
context.goNamed(
  MainAppRoutes.lyricEditor.name,
  pathParameters: {'id': '123'},
  extra: LrcModel(id: '123', title: 'Song'),
);

// Receive extra data
GoRoute(
  path: '/lyric/:id/edit',
  builder: (context, state) {
    final lyric = state.extra as LrcModel?;
    return LyricEditorPage(lyric: lyric);
  },
)
```

## Deep Linking

### Configure Deep Links

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="floatinglyric"
    android:host="app" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>floatinglyric</string>
    </array>
    <key>CFBundleURLName</key>
    <string>app</string>
  </dict>
</array>
```

### Handle Deep Links

GoRouter automatically handles deep links matching route paths:

```
floatinglyric://app/lyric/123       → LyricDetailPage(id: '123')
floatinglyric://app/local-lyrics    → LocalLyricsPage()
```

## Navigation Shell

### MainAppShell (Bottom Nav)

```dart
class MainAppShell extends StatelessWidget {
  const MainAppShell({required this.navigationShell});

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

## Error Handling

### Custom Error Page

```dart
GoRouter(
  errorBuilder: (context, state) => ErrorPage(
    error: state.error,
    uri: state.uri,
  ),
  // ...
)
```

```dart
class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.error, required this.uri});

  final Exception? error;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${uri.path}'),
            if (error != null) Text('Error: $error'),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## MaterialApp Integration

### Setup

```dart
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Floating Lyric',
      theme: ThemeData(...),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
```

## Common Navigation Scenarios

### 1. Bottom Tab Navigation

```dart
// Switch to specific tab
navigationShell.goBranch(1); // Go to "Local Lyrics" tab
```

### 2. Navigate to Detail Page

```dart
// From list item
onTap: () {
  context.goNamed(
    MainAppRoutes.lyricDetail.name,
    pathParameters: {'id': lyric.id},
  );
}
```

### 3. Edit Flow with Result

```dart
// Push editor
final edited = await context.pushNamed<bool>(
  MainAppRoutes.lyricEditor.name,
  pathParameters: {'id': lyric.id},
);

// In editor, pop with result
if (saved) {
  context.pop(true);
}

// Back in list, refresh if edited
if (edited == true) {
  context.read<LyricListBloc>().add(const LyricListEvent.started());
}
```

### 4. Conditional Navigation

```dart
// Check permission before navigating
void navigateToSettings() {
  final hasPermission = /* check */;
  if (hasPermission) {
    context.goNamed(MainAppRoutes.settings.name);
  } else {
    // Show permission dialog
    showDialog(...);
  }
}
```

### 5. Navigate and Reset Stack

```dart
// Go to home and clear stack
context.go(MainAppRoutes.home.path);
```

## Debugging Routes

### Print Current Location

```dart
print(GoRouterState.of(context).uri);
print(GoRouterState.of(context).matchedLocation);
```

### Enable Debug Logging

```dart
GoRouter(
  debugLogDiagnostics: true,
  // ...
)
```

## Best Practices

### DO

✅ **Use route enums** for type safety  
✅ **Use freezed for path parameters** (type safety)  
✅ **Use named routes** for clarity  
✅ **Handle deep links** for all public pages  
✅ **Provide error pages** for 404s  
✅ **Use StatefulShellRoute** for persistent tabs  
✅ **Extract route configuration** into separate files  
✅ **Use `extra` for complex objects** (not serialized in URL)  
✅ **Check `canPop()`** before calling `pop()`

### DON'T

❌ **Don't hardcode paths** in navigation calls  
❌ **Don't navigate without context** (use GoRouter.of)  
❌ **Don't forget to handle back button**  
❌ **Don't mix navigation patterns** (named vs path)  
❌ **Don't put sensitive data in path/query params**  
❌ **Don't create circular redirects**  
❌ **Don't forget to handle errors**

## Common Routes in Floating Lyric

### Main App Routes

| Route         | Path              | Purpose           |
| ------------- | ----------------- | ----------------- |
| `home`        | `/`               | Home page         |
| `localLyrics` | `/local-lyrics`   | Lyric list        |
| `settings`    | `/settings`       | Settings page     |
| `lyricDetail` | `/lyric/:id`      | Lyric detail view |
| `lyricEditor` | `/lyric/:id/edit` | Edit lyric        |
| `createLyric` | `/lyric/create`   | Create new lyric  |

### Navigation Patterns

```dart
// Home → Local Lyrics → Detail → Editor
context.goNamed(MainAppRoutes.home.name);
context.goNamed(MainAppRoutes.localLyrics.name);
context.pushNamed(MainAppRoutes.lyricDetail.name, pathParameters: {'id': '123'});
context.pushNamed(MainAppRoutes.lyricEditor.name, pathParameters: {'id': '123'});
```

## Related Skills

- [Route Definition](route-definition/SKILL.md) - Detailed route patterns
- [Page Architecture](../architecture/page-architecture/SKILL.md) - How pages are structured
- [State Management](../state-management/SKILL.md) - Managing state across routes
- [Freezed Models](../code-generation/freezed-models/SKILL.md) - Creating path parameters

## Resources

- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [GoRouter Examples](https://github.com/flutter/packages/tree/main/packages/go_router/example)
- [Deep Linking Guide](https://docs.flutter.dev/ui/navigation/deep-linking)
