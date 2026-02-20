---
name: architecture-overview
description: High-level architecture overview of the Floating Lyric Flutter app, including dual-app structure, layered architecture, and design patterns. Use this skill to understand the overall system design.
license: MIT
---

# Architecture Overview

This skill provides a high-level overview of the Floating Lyric application architecture.

## System Architecture

The Floating Lyric app has a unique **dual-app architecture** consisting of two separate Flutter applications running in the same project:

```
┌─────────────────────────────────────┐
│      Floating Lyric System          │
├─────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐ │
│  │   Main App   │  │ Overlay App  │ │
│  │              │  │              │ │
│  │  • Settings  │  │  • Floating  │ │
│  │  • Lyric DB  │  │    Lyric     │ │
│  │  • Manager   │  │    Display   │ │
│  │              │  │              │ │
│  └──────────────┘  └──────────────┘ │
│         ↕               ↕            │
│    Message Channels (Platform)      │
│         ↕               ↕            │
│  ┌──────────────────────────────┐   │
│  │    Shared Data Layer         │   │
│  │  • Hive (Lyrics)             │   │
│  │  • SharedPreferences         │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Main App

**Entry Point**: `main()` in [main.dart](../../lib/main.dart)

**Purpose**: Primary user interface for managing the application

**Features**:

- User onboarding
- Permission management
- Lyric database management (CRUD)
- Settings configuration
- Online lyric search
- Local file import
- Overlay window configuration

**Location**: `lib/apps/main/`

### Overlay App

**Entry Point**: `overlayView()` in [main.dart](../../lib/main.dart#L44)

**Purpose**: System overlay window for displaying floating lyrics

**Features**:

- Floating lyrics display
- Always-on-top overlay window
- Media state listening
- Lyric synchronization
- Minimal UI for distraction-free viewing

**Location**: `lib/apps/overlay/`

### Communication Between Apps

The two apps communicate via **IsolateNameServer** for message passing:

```dart
// Main App → Overlay App
ToOverlayMsgService
  ↓ (SendPort)
IsolateNameServer.lookupPortByName('overlay_port')
  ↓ (ReceivePort)
OverlayApp receives message

// Overlay App → Main App
ToMainMsgService
  ↓ (SendPort)
IsolateNameServer.lookupPortByName('main_port')
  ↓ (ReceivePort)
MainApp receives message
```

**How it works**:

- Each app registers a `ReceivePort` with a named port using `IsolateNameServer`
- The other app looks up this port by name and sends messages via `SendPort`
- Messages are JSON-serialized for cross-isolate communication

See [Dual App Pattern](dual-app-pattern/SKILL.md) for details.

## Layered Architecture

The app follows a strict **layered architecture** with clear separation of concerns:

### Architecture Layers

```
┌─────────────────────────────────────┐
│         UI Layer (Widgets)          │
│  • Pages, Widgets, Shells           │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│    State Management (BLoC)          │
│  • Events, States, Blocs            │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   Business Logic (Services)         │
│  • Data transformation, validation  │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│    Data Access (Repositories)       │
│  • CRUD operations                  │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│  Data Sources (Hive, API, Prefs)    │
│  • Persistent storage, APIs         │
└─────────────────────────────────────┘
```

**Data Flow**: UI → BLoC → Service → Repository → Data Source

See [Repository Pattern](repository-pattern/SKILL.md) for detailed explanation.

## Page Architecture

Each page follows a **three-layer structure** using Dart's part directive:

```
page_name/
├── page.dart          # Composition
├── _dependency.dart   # Dependency injection
├── _listener.dart     # Side effects
└── _view.dart         # UI rendering
```

**Flow**: Page → Dependency (inject) → Listener (side effects) → View (render)

See [Page Architecture](page-architecture/SKILL.md) for details.

## State Management Pattern

### BLoC Pattern

The app uses **flutter_bloc** for state management following the BLoC pattern:

```dart
User Action (UI)
  ↓
Event (e.g., SearchUpdated)
  ↓
BLoC (processes event)
  ↓
State (new immutable state)
  ↓
UI (rebuilds with new state)
```

**Key Principles**:

- Events are inputs (user actions, lifecycle events)
- States are outputs (UI state snapshots)
- BLoCs transform events into states
- BLoCs coordinate services
- UI only dispatches events and renders states

### BLoC Organization

```
lib/blocs/feature_name/
├── feature_name_bloc.dart      # BLoC implementation
├── feature_name_event.dart     # Event definitions
├── feature_name_state.dart     # State definitions
└── *.freezed.dart              # Generated files
```

See [State Management](../../state-management/SKILL.md) for details.

## Data Models

### Immutable Models with Freezed

All data models use **freezed** for immutability and code generation:

```dart
@freezed
class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
    String? artist,
    String? content,
    String? fileName,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
```

**Benefits**:

- Immutability (no accidental mutations)
- copyWith method (state updates)
- Equality (value comparison)
- JSON serialization
- Union types for states/events

## Routing & Navigation

### GoRouter

The app uses **go_router** for declarative routing:

```dart
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
    // ...
  ],
)
```

**Features**:

- Declarative routing
- Deep linking support
- Route guards (permission-based)
- Type-safe navigation
- Path parameters with freezed

**Location**: `lib/routes/`

See [Routing Navigation](../../routing-navigation/SKILL.md) for details.

## Data Persistence

### Hive (Primary Database)

**Purpose**: Local lyric storage

```dart
final Box<LrcModel> lrcBox = await Hive.openBox<LrcModel>('lrc');
```

**Features**:

- Fast NoSQL database
- Type-safe with adapters
- Box-based storage
- Efficient queries

### SharedPreferences

**Purpose**: App settings and user preferences

```dart
final SharedPreferences pref = await SharedPreferences.getInstance();
```

**Features**:

- Simple key-value storage
- Persistent settings
- User preferences

See [Data Persistence](../../data-persistence/SKILL.md) for details.

## Code Generation

The project relies heavily on **code generation**:

| Generator         | Purpose            | Output                |
| ----------------- | ------------------ | --------------------- |
| freezed           | Immutable models   | `*.freezed.dart`      |
| json_serializable | JSON serialization | `*.g.dart`            |
| hive_generator    | Type adapters      | `*_adapter.g.dart`    |
| go_router_builder | Routes             | `app_router.g.dart`   |
| flutter_gen       | Asset references   | `gen/assets.gen.dart` |

**Command**: `fvm dart run build_runner build -d`

See [Code Generation](../../code-generation/SKILL.md) for details.

## Key Design Patterns

### 1. Repository Pattern

Separates data access from business logic

- Repositories: Data access
- Services: Business logic
- BLoCs: State management

### 2. Dependency Injection

Services and repositories injected via:

- BlocProvider
- context.read<T>()
- Constructor injection

### 3. Part Directive Pattern

Pages split into focused files:

- Dependency, Listener, View layers

### 4. Event-Driven Architecture

BLoCs use events for all state changes:

- User actions → Events
- Events → State updates
- States → UI rebuilds

### 5. Immutability

All models and states are immutable:

- Freezed for models
- States never mutate
- copyWith for updates

## Project Structure

```
lib/
├── apps/              # App entry points
│   ├── main/         # Main app
│   └── overlay/      # Overlay app
├── blocs/            # State management (BLoC)
├── models/           # Data models (freezed)
├── repos/            # Repositories (data access)
├── services/         # Services (business logic)
├── routes/           # Router configuration
├── shells/           # App shells/layouts
├── widgets/          # Reusable widgets
├── l10n/             # Localization
├── hive/             # Hive type adapters
├── utils/            # Utilities
├── enums/            # Enumerations
└── main.dart         # Entry point
```

## Technology Stack

### Core

- **Flutter**: 3.38.6 (via FVM)
- **Dart**: 3.9.2+

### State Management

- **flutter_bloc**: ^9.1.1

### Routing

- **go_router**: ^16.2.4

### Data & Models

- **freezed**: ^3.2.3
- **json_serializable**: ^6.11.1
- **hive_ce**: ^2.14.0

### Platform Integration

- **firebase_core**: ^4.1.1
- **firebase_crashlytics**: ^5.0.2
- **firebase_analytics**: ^12.0.2

### UI

- **google_fonts**: ^6.3.2
- **lottie**: ^3.3.1
- **animated_text_kit**: ^4.3.0

See [pubspec.yaml](../../pubspec.yaml) for full list.

## Development Workflow

1. **Setup**: Install FVM, dependencies, generate code
2. **Development**: Follow layered architecture
3. **Testing**: Unit tests, widget tests, BLoC tests
4. **Building**: Release builds for Android/iOS

See [Development Workflow](../../development/SKILL.md) for details.

## Related Skills

- [Repository Pattern](repository-pattern/SKILL.md) - Data flow architecture
- [Page Architecture](page-architecture/SKILL.md) - Page structure
- [State Management](../../state-management/SKILL.md) - BLoC pattern
- [Development Workflow](../../development/SKILL.md) - Development process
