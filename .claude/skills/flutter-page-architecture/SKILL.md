---
name: flutter-page-architecture
description: Create Flutter pages following a layered architecture pattern with separated dependency injection, listeners, and view components. Use this skill when creating new pages in Flutter apps, especially when the user mentions creating a page with dependency/listener/view separation, or when working in projects that follow this architectural pattern. Keywords - Flutter page structure, dependency injection, state listeners, view layer, page architecture, Flutter separation of concerns.
license: MIT
---

# Flutter Page Architecture

This skill helps create Flutter pages using a layered architecture pattern that separates concerns into three distinct layers: Dependency, Listener, and View.

## Architecture Overview

Each page consists of four files using Dart's `part` directive system:

```
page_name/
├── page.dart          # Entry point and composition
├── _dependency.dart   # Dependency injection layer
├── _listener.dart     # State listening layer
└── _view.dart         # UI implementation layer
```

**Flow**: Page → Dependency → Listener → View

## File Structure

### `page.dart` - Entry Point

The main file that:

- Declares the public page widget
- Uses `part` directives to include private components
- Composes the three layers together

```dart
import 'package:flutter/widgets.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class PageNamePage extends StatelessWidget {
  const PageNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(
        builder: (context) => const _View(),
      ),
    );
  }
}
```

### `_dependency.dart` - Dependency Layer

Handles:

- Provider setup
- Repository/service injection
- BLoC/Cubit creation
- Any resources that need disposal

```dart
part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // Add providers, repositories, BLoCs here
    // Example with BlocProvider:
    // return BlocProvider(
    //   create: (context) => PageNameBloc(
    //     repository: context.read<Repository>(),
    //   ),
    //   child: Builder(builder: builder),
    // );

    return Builder(builder: builder);
  }
}
```

### `_listener.dart` - Listener Layer

Handles:

- State change reactions (navigation, dialogs, snackbars)
- Side effects from state changes
- Event listeners that don't affect UI directly

```dart
part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // Add listeners here
    // Example with BlocListener:
    // return BlocListener<PageNameBloc, PageNameState>(
    //   listener: (context, state) {
    //     if (state.shouldNavigate) {
    //       Navigator.of(context).push(...);
    //     }
    //   },
    //   child: Builder(builder: builder),
    // );

    return Builder(builder: builder);
  }
}
```

### `_view.dart` - View Layer

Pure UI implementation:

- Widgets and layout
- Event handlers (calling BLoC methods)
- BlocBuilder/Consumer widgets
- No business logic

```dart
part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    // Implement UI here
    return const Placeholder();
  }
}
```

## Workflow

When creating a new page:

1. **Create folder**: `lib/pages/page_name/`
2. **Create `page.dart`**:
   - Define public page class
   - Add part directives
   - Compose layers
3. **Create `_dependency.dart`**:
   - Add providers/BLoCs
   - Inject dependencies
4. **Create `_listener.dart`**:
   - Add side effect listeners
   - Handle navigation/dialogs
5. **Create `_view.dart`**:
   - Implement UI
   - Wire up state

## Benefits

- **Separation of concerns**: Each layer has a single responsibility
- **Testability**: Easy to test each layer independently
- **Readability**: Clear structure shows what each part does
- **Maintainability**: Changes are isolated to appropriate layers
- **Consistency**: Enforces uniform architecture across pages

## Common Patterns

### With Provider

```dart
// _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageViewModel()),
      ],
      child: Builder(builder: builder),
    );
  }
}
```

### With BLoC

```dart
// _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageBloc(
        repository: context.read<Repository>(),
      ),
      child: Builder(builder: builder),
    );
  }
}

// _listener.dart
class _Listener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PageBloc, PageState>(
      listener: (context, state) {
        if (state is PageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Builder(builder: builder),
    );
  }
}
```

### With Riverpod

```dart
// _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Builder(builder: builder),
    );
  }
}
```

## When to Use Each Layer

**\_dependency.dart**:

- Creating BLoCs, ViewModels, Controllers
- Injecting repositories or services
- Setting up providers
- Managing resources that need disposal

**\_listener.dart**:

- Navigation based on state
- Showing dialogs/snackbars
- Analytics events
- Any side effects that don't directly update UI

**\_view.dart**:

- All UI widgets
- Layout and styling
- Calling BLoC/ViewModel methods
- Reading state for display

## Templates

See `assets/` folder for ready-to-use templates:

- `assets/page_template.dart`
- `assets/dependency_template.dart`
- `assets/listener_template.dart`
- `assets/view_template.dart`

To use templates, copy and replace `{{PageName}}` with your page name (PascalCase) and `{{page_name}}` with the snake_case version.
