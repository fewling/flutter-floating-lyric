---
name: state-management
description: State management overview using BLoC pattern in the Floating Lyric app. Covers BLoC architecture, event/state flow, dependency injection, and patterns. Use this as an entry point to understanding state management in the app.
license: MIT
---

# State Management

This skill provides an overview of state management in the Floating Lyric app using the BLoC (Business Logic Component) pattern with flutter_bloc.

## Overview

The Floating Lyric app uses **flutter_bloc** (v9.1.1) for state management, following the BLoC pattern throughout the application.

**Package**: `flutter_bloc: ^9.1.1`

## BLoC Pattern Fundamentals

### What is BLoC?

BLoC (Business Logic Component) is a design pattern that separates:

- **Business logic** from UI
- **State management** from presentation
- **Events** (inputs) from **States** (outputs)

### Flow Architecture

```
User Interaction (UI)
        ↓
    Event (Input)
        ↓
    BLoC (Logic)
        ↓
    State (Output)
        ↓
UI Rebuilds (Reactive)
```

### Core Concepts

1. **Events**: User actions or lifecycle changes

   ```dart
   LyricListEvent.searchUpdated('query')
   ```

2. **States**: UI data snapshots

   ```dart
   LyricListState(lyrics: [...], status: Status.success)
   ```

3. **BLoC**: Transforms events into states

   ```dart
   class LyricListBloc extends Bloc<LyricListEvent, LyricListState> { ... }
   ```

4. **UI**: Dispatches events, renders states
   ```dart
   context.read<LyricListBloc>().add(event);
   BlocBuilder<LyricListBloc, LyricListState>(...)
   ```

## BLoC Architecture in Floating Lyric

### Layer Separation

```
┌─────────────────────────────────────┐
│  UI Layer                           │
│  • Dispatch events                  │
│  • Render states                    │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│  BLoC Layer                         │
│  • Handle events                    │
│  • Coordinate services              │
│  • Emit states                      │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│  Service Layer                      │
│  • Business logic                   │
│  • Data transformation              │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│  Repository Layer                   │
│  • Data access                      │
│  • CRUD operations                  │
└─────────────────────────────────────┘
```

### Key Principles

1. **BLoCs don't contain business logic** - delegate to services
2. **BLoCs coordinate services** - orchestrate multiple service calls
3. **BLoCs manage state** - track UI state and operation status
4. **BLoCs are injected** - via dependency layer in pages

## BLoC Structure

### File Organization

Each BLoC feature has its own folder:

```
lib/blocs/feature_name/
├── feature_name_bloc.dart          # BLoC implementation
├── feature_name_event.dart         # Event definitions
├── feature_name_state.dart         # State definitions
└── feature_name_bloc.freezed.dart  # Generated
```

See [BLoC Structure](bloc-structure/SKILL.md) for detailed patterns.

## Example: LyricListBloc

### Event Definition

```dart
@freezed
sealed class LyricListEvent with _$LyricListEvent {
  const factory LyricListEvent.started() = _Started;
  const factory LyricListEvent.searchUpdated(String searchTerm) = _SearchUpdated;
  const factory LyricListEvent.deleteRequested(LrcModel lyric) = _DeleteRequested;
}
```

### State Definition

```dart
@freezed
sealed class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcModel>[]) List<LrcModel> lyrics,
    @Default(DeleteStatus.initial) DeleteStatus deleteStatus,
  }) = _LyricListState;
}

enum DeleteStatus { initial, deleting, deleted, error }
```

### BLoC Implementation

```dart
class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  LyricListBloc({
    required LocalDbService localDbService,
  })  : _localDbService = localDbService,
        super(const LyricListState()) {
    on<LyricListEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _SearchUpdated() => _onSearchUpdated(event, emit),
        _DeleteRequested() => _onDeleteRequested(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;

  Future<void> _onStarted(_Started event, Emitter<LyricListState> emit) async {
    final lyrics = _localDbService.getAllLyrics();
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onSearchUpdated(
    _SearchUpdated event,
    Emitter<LyricListState> emit,
  ) async {
    final lyrics = _localDbService.searchLyrics(event.searchTerm);
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<LyricListState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: DeleteStatus.deleting));

    try {
      await _localDbService.deleteLrc(event.lyric);
      final updatedLyrics = state.lyrics.where((l) => l.id != event.lyric.id).toList();
      emit(state.copyWith(
        lyrics: updatedLyrics,
        deleteStatus: DeleteStatus.deleted,
      ));
    } catch (e) {
      emit(state.copyWith(deleteStatus: DeleteStatus.error));
    }
  }
}
```

## Using BLoCs in the App

### 1. Create BLoC (Dependency Layer)

```dart
// page.dart -> _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LyricListBloc(
        localDbService: context.read<LocalDbService>(),
      )..add(const LyricListEvent.started()),
      child: Builder(builder: builder),
    );
  }
}
```

### 2. Listen to State Changes (Listener Layer)

```dart
// page.dart -> _listener.dart
class _Listener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricListBloc, LyricListState>(
      listener: (context, state) {
        if (state.deleteStatus == DeleteStatus.deleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deleted successfully')),
          );
        }
      },
      child: Builder(builder: builder),
    );
  }
}
```

### 3. Render State (View Layer)

```dart
// page.dart -> _view.dart
class _View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LyricListBloc, LyricListState>(
      builder: (context, state) {
        if (state.lyrics.isEmpty) {
          return const Text('No lyrics found');
        }

        return ListView.builder(
          itemCount: state.lyrics.length,
          itemBuilder: (context, index) {
            final lyric = state.lyrics[index];
            return ListTile(
              title: Text(lyric.title ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Dispatch event
                  context.read<LyricListBloc>().add(
                    LyricListEvent.deleteRequested(lyric),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
```

## BLoC Widgets

### BlocProvider

Creates and provides a BLoC to widget tree:

```dart
BlocProvider(
  create: (context) => MyBloc(),
  child: MyWidget(),
)
```

### MultiBlocProvider

Provides multiple BLoCs:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => Bloc1()),
    BlocProvider(create: (context) => Bloc2()),
  ],
  child: MyWidget(),
)
```

### BlocBuilder

Rebuilds widget when state changes:

```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    return Text(state.data);
  },
)
```

**With buildWhen**:

```dart
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) => previous.data != current.data,
  builder: (context, state) {
    return Text(state.data);
  },
)
```

### BlocListener

Executes side effects on state changes:

```dart
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    if (state.showError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
  child: MyWidget(),
)
```

**With listenWhen**:

```dart
BlocListener<MyBloc, MyState>(
  listenWhen: (previous, current) => previous.status != current.status,
  listener: (context, state) {
    // Only called when status changes
  },
  child: MyWidget(),
)
```

### BlocConsumer

Combines BlocBuilder and BlocListener:

```dart
BlocConsumer<MyBloc, MyState>(
  listener: (context, state) {
    // Side effects
    if (state.showDialog) {
      showDialog(...);
    }
  },
  builder: (context, state) {
    // UI rendering
    return Text(state.data);
  },
)
```

## Common BLoC Patterns

### 1. List Management

```dart
// Load, search, filter, add, delete items
class ListBloc extends Bloc<ListEvent, ListState> {
  // Events: load, filter, add, delete
  // State: List<Item>, filters, status
}
```

### 2. Form Management

```dart
// Field updates, validation, submission
class FormBloc extends Bloc<FormEvent, FormState> {
  // Events: fieldUpdated, submit, reset
  // State: field values, validation errors, submit status
}
```

### 3. Settings Management

```dart
// Load settings, update individual settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Events: load, updateSetting
  // State: settings object, save status
}
```

### 4. Permission Management

```dart
// Check and request permissions
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  // Events: check, request
  // State: permission statuses
}
```

### 5. Async Operation Tracking

```dart
@freezed
sealed class MyState with _$MyState {
  const factory MyState({
    @Default(LoadStatus.initial) LoadStatus loadStatus,
    @Default(SaveStatus.initial) SaveStatus saveStatus,
    @Default(DeleteStatus.initial) DeleteStatus deleteStatus,
  }) = _MyState;
}
```

## BLoC Communication

### Between Pages (Navigation)

```dart
// Pass data via route parameters or state
context.goNamed(
  'detail',
  extra: {'id': selectedId},
);
```

### Between Apps (Main ↔ Overlay)

```dart
// Via message channels
ToOverlayMessageService.send(message);

// Via shared data layer (Hive, SharedPreferences)
```

## Testing BLoCs

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<MyBloc, MyState>(
  'emits new state when event added',
  build: () => MyBloc(service: mockService),
  act: (bloc) => bloc.add(const Event.started()),
  expect: () => [
    const MyState(status: Status.loading),
    const MyState(status: Status.success, data: [...]),
  ],
);
```

## Best Practices

### DO

✅ **Use freezed for events and states** (immutability)  
✅ **Inject services via constructor** (testability)  
✅ **Use enums for status tracking**  
✅ **Handle errors in event handlers**  
✅ **Initialize BLoCs with events** in dependency layer  
✅ **Use BlocListener for side effects** (navigation, dialogs)  
✅ **Use BlocBuilder for UI rendering**  
✅ **Keep BLoCs focused** (single responsibility)

### DON'T

❌ **Don't put business logic in BLoCs** (use services)  
❌ **Don't access repositories directly** (use services)  
❌ **Don't mutate state** (use copyWith)  
❌ **Don't emit state in UI** (only add events)  
❌ **Don't create BLoCs in View layer** (use dependency layer)  
❌ **Don't forget to close streams** (automatic with BloProvider)  
❌ **Don't mix presentation and business logic**

## Common BLoCs in Floating Lyric

| BLoC                        | Purpose               | Location                             |
| --------------------------- | --------------------- | ------------------------------------ |
| `AppInfoBloc`               | App version and info  | `lib/blocs/app_info/`                |
| `LyricListBloc`             | Lyric list management | `lib/blocs/lyric_list/`              |
| `MediaListenerBloc`         | Media playback state  | `lib/blocs/media_listener/`          |
| `PermissionBloc`            | Permission management | `lib/blocs/permission/`              |
| `PreferenceBloc`            | User preferences      | `lib/blocs/preference/`              |
| `OverlayWindowSettingsBloc` | Overlay config        | `lib/blocs/overlay_window_settings/` |

## Related Skills

- [BLoC Structure](bloc-structure/SKILL.md) - Detailed BLoC organization patterns
- [Page Architecture](../architecture/page-architecture/SKILL.md) - Where BLoCs fit in pages
- [Repository Pattern](../architecture/repository-pattern/SKILL.md) - Service layer integration
- [Freezed Models](../code-generation/freezed-models/SKILL.md) - Creating events/states
