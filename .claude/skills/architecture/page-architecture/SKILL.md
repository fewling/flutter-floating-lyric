---
name: page-architecture
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

1. **Create folder**: `lib/apps/{main|overlay}/pages/page_name/`
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

## Real Example from Floating Lyric

### Example: LocalLyricsPage

Structure:

```
lib/apps/main/pages/local_lyrics/
├── page.dart           # Entry point
├── _dependency.dart    # Injects LyricListBloc
├── _listener.dart      # Handles delete confirmation dialogs
└── _view.dart          # Displays lyric list UI
```

**page.dart**:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/lyric_list/lyric_list_bloc.dart';
import '../../../../services/db/local/local_db_service.dart';
import '../../../../services/lrc/lrc_process_service.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class LocalLyricsPage extends StatelessWidget {
  const LocalLyricsPage({super.key});

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

**\_dependency.dart**:

```dart
part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LyricListBloc(
        localDbService: context.read<LocalDbService>(),
        lrcProcessorService: context.read<LrcProcessorService>(),
      )..add(const LyricListEvent.started()),
      child: Builder(builder: builder),
    );
  }
}
```

**\_listener.dart**:

```dart
part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricListBloc, LyricListState>(
      listener: (context, state) {
        if (state.deleteStatus == DeleteStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lyric deleted successfully')),
          );
        }
      },
      child: Builder(builder: builder),
    );
  }
}
```

**\_view.dart**:

```dart
part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Lyrics')),
      body: BlocBuilder<LyricListBloc, LyricListState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.lyrics.length,
            itemBuilder: (context, index) {
              final lyric = state.lyrics[index];
              return ListTile(
                title: Text(lyric.title ?? 'Unknown'),
                subtitle: Text(lyric.artist ?? ''),
                onTap: () {
                  // Navigate to detail page
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

## Benefits

- **Separation of concerns**: Each layer has a single responsibility
- **Testability**: Easy to test each layer independently
- **Readability**: Clear structure shows what each part does
- **Maintainability**: Changes are isolated to appropriate layers
- **Consistency**: Enforces uniform architecture across pages
- **Dependency Injection**: Clean injection of services and BLoCs
- **Side Effect Management**: Clear place for navigation and dialogs

## Common Patterns in Floating Lyric

### Pattern 1: BLoC with Multiple Services

```dart
// _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeatureBloc(
        localDbService: context.read<LocalDbService>(),
        lrcProcessorService: context.read<LrcProcessorService>(),
        messageService: context.read<ToOverlayMessageService>(),
      )..add(const FeatureEvent.started()),
      child: Builder(builder: builder),
    );
  }
}
```

### Pattern 2: Navigation Listener

```dart
// _listener.dart
class _Listener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<FeatureBloc, FeatureState>(
      listener: (context, state) {
        if (state.shouldNavigateToDetail && state.selectedId != null) {
          context.push('/detail/${state.selectedId}');
        }
      },
      child: Builder(builder: builder),
    );
  }
}
```

### Pattern 3: Multi-BLoC Listener

```dart
// _listener.dart
class _Listener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FeatureBloc, FeatureState>(
          listener: (context, state) {
            // Handle FeatureBloc state
          },
        ),
        BlocListener<PermissionBloc, PermissionState>(
          listener: (context, state) {
            // Handle PermissionBloc state
          },
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
```

### Pattern 4: Complex View with Multiple Builders

```dart
// _view.dart
class _View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FeatureBloc, FeatureState>(
          builder: (context, state) {
            return Text(state.title);
          },
        ),
      ),
      body: BlocBuilder<FeatureBloc, FeatureState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }

          if (state.hasError) {
            return ErrorWidget(error: state.error);
          }

          return ListView.builder(/* ... */);
        },
      ),
    );
  }
}
```

## When to Use Each Layer

**\_dependency.dart** (Dependency Injection Layer):

- Creating BLoCs with injected services
- Setting up multiple providers
- Managing page-level dependencies
- Initializing page state (e.g., `..add(const Started())`)

**\_listener.dart** (Side Effects Layer):

- Navigation based on state changes
- Showing dialogs or snackbars
- Displaying error messages
- Analytics/logging events
- Any action that doesn't directly update the widget tree

**\_view.dart** (UI Layer):

- All widgets and layouts
- BlocBuilder widgets for state-based rendering
- Event dispatching (e.g., `context.read<Bloc>().add(Event)`)
- User interaction handlers
- UI composition

## Templates

See `assets/` folder for ready-to-use templates:

- `assets/page_template.dart`
- `assets/dependency_template.dart`
- `assets/listener_template.dart`
- `assets/view_template.dart`

To use templates, copy and replace `{{PageName}}` with your page name (PascalCase) and `{{page_name}}` with the snake_case version.

## Scripts

See `scripts/` folder for automation scripts:

- `scripts/scaffold_page.py` - Automates page scaffolding with layered architecture

To use the script, run:

```bash
python3 .claude/skills/flutter-page-architecture/scripts/scaffold_page.py <page-name> <directory_path>
```

## Best Practices

### DO

✅ Keep \_View pure (no business logic)  
✅ Use BlocListener in \_Listener for side effects  
✅ Inject all services through \_Dependency  
✅ Initialize BLoCs with events in \_Dependency  
✅ Keep files focused on their layer's responsibility

### DON'T

❌ Create BLoCs directly in \_View  
❌ Put UI widgets in \_Listener  
❌ Mix state rendering with side effects

## Related Skills

- [Repository Pattern](../repository-pattern/SKILL.md) - Understanding the full architecture
- [Code Conventions](../../development/code-conventions/SKILL.md) - File naming and organization
- [BLoC Structure](../../state-management/bloc-structure/SKILL.md) - BLoC organization patterns
