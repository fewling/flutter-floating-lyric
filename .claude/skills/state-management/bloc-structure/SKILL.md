---
name: bloc-structure
description: Organizing BLoC code with events, states, and bloc files in the Floating Lyric app. Covers file organization, freezed integration, event/state patterns, and best practices. Use this when creating or modifying BLoCs.
license: MIT
---

# BLoC Structure

This skill documents how to organize BLoC (Business Logic Component) code in the Floating Lyric app, including file structure, event/state patterns, and best practices.

## File Organization

Each BLoC feature has its own folder with separate files:

```
lib/blocs/feature_name/
├── feature_name_bloc.dart          # BLoC implementation
├── feature_name_event.dart         # Event definitions
├── feature_name_state.dart         # State definitions
├── feature_name_bloc.freezed.dart  # Generated (freezed)
└── (optional) feature_name_bloc.g.dart  # Generated (JSON)
```

### Example: LyricListBloc

```
lib/blocs/lyric_list/
├── lyric_list_bloc.dart
├── lyric_list_event.dart
├── lyric_list_state.dart
└── lyric_list_bloc.freezed.dart
```

## BLoC File Structure

### 1. Event File (`*_event.dart`)

**Purpose**: Define all possible user actions and lifecycle events

```dart
part of 'lyric_list_bloc.dart';

@freezed
sealed class LyricListEvent with _$LyricListEvent {
  // Lifecycle events
  const factory LyricListEvent.started() = _Started;

  // User action events
  const factory LyricListEvent.searchUpdated(String searchTerm) = _SearchUpdated;
  const factory LyricListEvent.deleteRequested(LrcModel lyric) = _DeleteRequested;
  const factory LyricListEvent.deleteAllRequested() = _DeleteAllRequested;
  const factory LyricListEvent.importLRCsRequested() = _ImportLRCsRequested;

  // Status reset events
  const factory LyricListEvent.deleteStatusHandled() = _DeleteStatusHandled;
}
```

**Key Points**:

- Use `@freezed` for immutability
- Use `sealed class` for exhaustive pattern matching
- Use `part of` to reference main BLoC file
- Name events as actions (past tense or present progressive)
- Group related events with comments

### 2. State File (`*_state.dart`)

**Purpose**: Define the UI state shape

```dart
part of 'lyric_list_bloc.dart';

@freezed
sealed class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcModel>[]) List<LrcModel> lyrics,
    @Default(LyricListDeleteStatus.initial) LyricListDeleteStatus deleteStatus,
    @Default(LyricListImportStatus.initial) LyricListImportStatus importStatus,
    @Default(<PlatformFile>[]) List<PlatformFile> failedImportFiles,
  }) = _LyricListState;
}

// Status enums for tracking async operations
enum LyricListDeleteStatus { initial, deleted, error }
enum LyricListImportStatus { initial, importing, error }

// Extension methods for convenience
extension LyricListDeleteStatusX on LyricListDeleteStatus {
  bool get isInitial => this == LyricListDeleteStatus.initial;
  bool get isDeleted => this == LyricListDeleteStatus.deleted;
  bool get isError => this == LyricListDeleteStatus.error;
}

extension LyricListImportStatusX on LyricListImportStatus {
  bool get isInitial => this == LyricListImportStatus.initial;
  bool get isImporting => this == LyricListImportStatus.importing;
  bool get isError => this == LyricListImportStatus.error;
}
```

**Key Points**:

- Single state class with all UI data
- Use `@Default()` for initial values
- Use enums for status tracking (loading, success, error)
- Add extension methods for status checks
- Keep state immutable

### 3. BLoC File (`*_bloc.dart`)

**Purpose**: Transform events into states

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lyric_model.dart';
import '../../services/db/local/local_db_service.dart';
import '../../services/lrc/lrc_process_service.dart';

part 'lyric_list_bloc.freezed.dart';
part 'lyric_list_event.dart';
part 'lyric_list_state.dart';

class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  LyricListBloc({
    required LocalDbService localDbService,
    required LrcProcessorService lrcProcessorService,
  })  : _localDbService = localDbService,
        _lrcProcessorService = lrcProcessorService,
        super(const LyricListState()) {
    // Register event handlers
    on<LyricListEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _SearchUpdated() => _onSearchUpdated(event, emit),
        _DeleteRequested() => _onDeleteRequested(event, emit),
        _DeleteAllRequested() => _onDeleteAllRequested(event, emit),
        _ImportLRCsRequested() => _onImportLRCsRequested(event, emit),
        _DeleteStatusHandled() => _onDeleteStatusHandled(event, emit),
      },
    );
  }

  final LrcProcessorService _lrcProcessorService;
  final LocalDbService _localDbService;

  // Event handlers
  Future<void> _onStarted(_Started event, Emitter<LyricListState> emit) async {
    final lyrics = _localDbService.getAllLyrics();
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onSearchUpdated(
    _SearchUpdated event,
    Emitter<LyricListState> emit,
  ) async {
    if (event.searchTerm.isEmpty) {
      add(const _Started());
      return;
    }

    final lyrics = _localDbService.searchLyrics(event.searchTerm);
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<LyricListState> emit,
  ) async {
    try {
      await _localDbService.deleteLrc(event.lyric);

      final lyrics = state.lyrics.where((l) => l.id != event.lyric.id).toList();
      emit(
        state.copyWith(
          lyrics: lyrics,
          deleteStatus: LyricListDeleteStatus.deleted,
        ),
      );
    } catch (e) {
      emit(state.copyWith(deleteStatus: LyricListDeleteStatus.error));
    }
  }

  void _onDeleteStatusHandled(
    _DeleteStatusHandled event,
    Emitter<LyricListState> emit,
  ) {
    emit(state.copyWith(deleteStatus: LyricListDeleteStatus.initial));
  }
}
```

**Key Points**:

- Extend `Bloc<Event, State>`
- Inject services via constructor
- Use `on<Event>()` with switch pattern matching (Dart 3+)
- Separate event handlers with private methods
- Use `emit()` to emit new states
- Handle errors within event handlers

## Event Patterns

### 1. Lifecycle Events

```dart
const factory Event.started() = _Started;
const factory Event.initialized() = _Initialized;
const factory Event.disposed() = _Disposed;
```

**Usage**: Initialize BLoC, load initial data

### 2. User Action Events

```dart
const factory Event.buttonPressed() = _ButtonPressed;
const factory Event.itemSelected(Item item) = _ItemSelected;
const factory Event.formSubmitted(String data) = _FormSubmitted;
```

**Usage**: Direct user interactions

### 3. Data Change Events

```dart
const factory Event.dataUpdated(Data data) = _DataUpdated;
const factory Event.filterChanged(Filter filter) = _FilterChanged;
const factory Event.searchTermChanged(String term) = _SearchTermChanged;
```

**Usage**: Data or filter updates

### 4. Status Reset Events

```dart
const factory Event.errorDismissed() = _ErrorDismissed;
const factory Event.statusReset() = _StatusReset;
```

**Usage**: Clear temporary states (errors, loading, etc.)

## State Patterns

### 1. Single State with Properties

**Most Common** - Used in Floating Lyric

```dart
@freezed
sealed class MyState with _$MyState {
  const factory MyState({
    @Default(<Item>[]) List<Item> items,
    @Default(Status.initial) Status status,
    String? errorMessage,
  }) = _MyState;
}

enum Status { initial, loading, success, error }
```

**Pros**:

- Simple state updates with `copyWith`
- Easy to add new properties
- Clear separation of data and status

### 2. Union Types (Multiple States)

**Alternative** - For complex state machines

```dart
@freezed
sealed class MyState with _$MyState {
  const factory MyState.initial() = _Initial;
  const factory MyState.loading() = _Loading;
  const factory MyState.loaded(List<Item> items) = _Loaded;
  const factory MyState.error(String message) = _Error;
}
```

**Pros**:

- Exhaustive pattern matching
- Clear state transitions
- Type-safe state access

**When to use**: Complex workflows with distinct states

### 3. Hybrid Approach

```dart
@freezed
sealed class MyState with _$MyState {
  const factory MyState.initial() = _Initial;
  const factory MyState.data({
    required List<Item> items,
    @Default(false) bool isLoading,
    String? error,
  }) = _DataState;
}
```

## Status Tracking Pattern

Use enums to track async operation status:

```dart
enum LoadStatus { initial, loading, success, error }
enum SaveStatus { initial, saving, saved, error }
enum DeleteStatus { initial, deleting, deleted, error }

@freezed
sealed class MyState with _$MyState {
  const factory MyState({
    @Default(LoadStatus.initial) LoadStatus loadStatus,
    @Default(SaveStatus.initial) SaveStatus saveStatus,
    @Default(DeleteStatus.initial) DeleteStatus deleteStatus,
  }) = _MyState;
}
```

**Benefits**:

- Track multiple operations independently
- Clear status transitions
- Easy to check status in UI

## Event Handler Patterns

### 1. Simple Handler

```dart
Future<void> _onEvent(Event event, Emitter<State> emit) async {
  final data = await _service.fetchData();
  emit(state.copyWith(data: data));
}
```

### 2. Handler with Loading State

```dart
Future<void> _onFetch(FetchEvent event, Emitter<State> emit) async {
  emit(state.copyWith(status: Status.loading));

  try {
    final data = await _service.fetchData();
    emit(state.copyWith(
      data: data,
      status: Status.success,
    ));
  } catch (e) {
    emit(state.copyWith(
      status: Status.error,
      errorMessage: e.toString(),
    ));
  }
}
```

### 3. Handler with Optimistic Update

```dart
Future<void> _onDelete(DeleteEvent event, Emitter<State> emit) async {
  // Optimistic update
  final updated = state.items.where((item) => item.id != event.id).toList();
  emit(state.copyWith(items: updated));

  try {
    await _service.delete(event.id);
    emit(state.copyWith(deleteStatus: DeleteStatus.deleted));
  } catch (e) {
    // Revert on error
    emit(state.copyWith(
      items: state.items,
      deleteStatus: DeleteStatus.error,
    ));
  }
}
```

### 4. Handler that Dispatches Another Event

```dart
Future<void> _onSearch(SearchEvent event, Emitter<State> emit) async {
  if (event.query.isEmpty) {
    // Dispatch another event
    add(const Event.cleared());
    return;
  }

  final results = _service.search(event.query);
  emit(state.copyWith(searchResults: results));
}
```

## BLoC Creation and Usage

### Creating a BLoC in Dependency Layer

```dart
// page.dart -> _dependency.dart
class _Dependency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LyricListBloc(
        localDbService: context.read<LocalDbService>(),
        lrcProcessorService: context.read<LrcProcessorService>(),
      )..add(const LyricListEvent.started()), // Initialize
      child: Builder(builder: builder),
    );
  }
}
```

### Dispatching Events in UI

```dart
// In _view.dart
ElevatedButton(
  onPressed: () {
    context.read<LyricListBloc>().add(
      LyricListEvent.deleteRequested(lyric),
    );
  },
  child: const Text('Delete'),
)
```

### Reading State in UI

```dart
// In _view.dart
BlocBuilder<LyricListBloc, LyricListState>(
  builder: (context, state) {
    if (state.deleteStatus.isDeleted) {
      return const Text('Deleted successfully');
    }

    return ListView.builder(
      itemCount: state.lyrics.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(state.lyrics[index].title ?? ''));
      },
    );
  },
)
```

### Listening to State Changes

```dart
// In _listener.dart
BlocListener<LyricListBloc, LyricListState>(
  listener: (context, state) {
    if (state.deleteStatus.isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lyric deleted')),
      );

      // Reset status
      context.read<LyricListBloc>().add(
        const LyricListEvent.deleteStatusHandled(),
      );
    }
  },
  child: Builder(builder: builder),
)
```

## Best Practices

### DO

✅ **Use freezed for events and states** (immutability, pattern matching)  
✅ **Separate events, states, and BLoC into different files**  
✅ **Use descriptive event names** (verbNoun pattern)  
✅ **Track async operation status with enums**  
✅ **Handle errors in event handlers**  
✅ **Use switch pattern matching** for event handling (Dart 3+)  
✅ **Use extension methods** for status checks  
✅ **Initialize BLoCs with events** in dependency layer

### DON'T

❌ **Don't put business logic in BLoCs** (use services)  
❌ **Don't access repositories directly** (use services)  
❌ **Don't emit state in UI** (only add events)  
❌ **Don't use `context.watch()` for dispatching events**  
❌ **Don't forget to handle all event types**  
❌ **Don't mutate state directly** (always use copyWith)  
❌ **Don't create BLoCs in UI directly** (use dependency layer)

## Common BLoC Patterns in Floating Lyric

### 1. List Management BLoC

```dart
// LyricListBloc, etc.
- Load list
- Search/filter list
- Add/delete items
- Refresh list
```

### 2. Form BLoC

```dart
// FormBloc patterns
- Field updates
- Validation
- Submit
- Reset
```

### 3. Settings BLoC

```dart
// PreferenceBloc
- Load settings
- Update individual settings
- Persist changes
```

### 4. Permission BLoC

```dart
// PermissionBloc
- Check permissions
- Request permissions
- Update permission status
```

## Testing BLoCs

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LyricListBloc', () {
    late MockLocalDbService mockService;
    late LyricListBloc bloc;

    setUp(() {
      mockService = MockLocalDbService();
      bloc = LyricListBloc(
        localDbService: mockService,
        lrcProcessorService: MockLrcProcessorService(),
      );
    });

    blocTest<LyricListBloc, LyricListState>(
      'emits lyrics when started',
      build: () {
        when(() => mockService.getAllLyrics()).thenReturn([]);
        return bloc;
      },
      act: (bloc) => bloc.add(const LyricListEvent.started()),
      expect: () => [
        const LyricListState(lyrics: []),
      ],
    );
  });
}
```

## Related Skills

- [Repository Pattern](../../architecture/repository-pattern/SKILL.md) - Understanding service layer
- [Page Architecture](../../architecture/page-architecture/SKILL.md) - Where to create BLoCs
- [Freezed Models](../../code-generation/freezed-models/SKILL.md) - Creating events/states
- [Code Conventions](../../development/code-conventions/SKILL.md) - Naming and organization
