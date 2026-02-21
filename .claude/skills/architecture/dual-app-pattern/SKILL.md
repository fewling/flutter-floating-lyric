---
name: dual-app-pattern
description: Detailed explanation of the unique dual-app architecture in Floating Lyric, covering main app, overlay app, communication patterns, and lifecycle management.
license: MIT
---

# Dual-App Pattern

This skill documents the unique **dual-app architecture** in the Floating Lyric application, where two separate Flutter apps run within a single project.

## Architecture Overview

```
┌────────────────────────────────────────────────┐
│         Floating Lyric System                  │
├────────────────────────────────────────────────┤
│                                                 │
│  ┌───────────────┐        ┌──────────────────┐ │
│  │   Main App    │        │   Overlay App    │ │
│  │   (main())    │        │ (overlayView())  │ │
│  ├───────────────┤        ├──────────────────┤ │
│  │ • Onboarding  │        │ • Floating UI    │ │
│  │ • Permissions │        │ • Lyric Display  │ │
│  │ • Settings    │        │ • Media Sync     │ │
│  │ • Lyric CRUD  │        │ • Minimal UI     │ │
│  │ • Config      │        │ • Always On Top  │ │
│  └───────────────┘        └──────────────────┘ │
│         │                         │             │
│         └──────────┬──────────────┘             │
│                    │                            │
│         ┌──────────▼───────────┐                │
│         │ IsolateNameServer    │                │
│         │ Message Passing      │                │
│         └──────────────────────┘                │
│                    │                            │
│         ┌──────────▼───────────┐                │
│         │  Shared Data Layer   │                │
│         │  • Hive (lrc box)    │                │
│         │  • SharedPreferences │                │
│         └──────────────────────┘                │
│                                                 │
└────────────────────────────────────────────────┘
```

## Entry Points

### Main App Entry

**File**: [lib/main.dart](../../../lib/main.dart)

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Error handling
  FlutterError.onError = (errorDetails) {
    logger.e('FlutterError: ${errorDetails.exceptionAsString()}');
    if (kDebugMode) return;
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Bootstrap shared resources
  final (pref, lrcModelBox) = await bootstrap();

  // Launch main app
  runApp(MainApp(pref: pref, lrcBox: lrcModelBox));
}
```

**Location**: `lib/apps/main/`

**Purpose**: Primary user-facing application

### Overlay App Entry

**File**: [lib/main.dart](../../../../lib/main.dart#L44)

```dart
@pragma('vm:entry-point')
Future<void> overlayView() async {
  WidgetsFlutterBinding.ensureInitialized();

  final (pref, lrcModelBox) = await bootstrap();

  runApp(
    LayoutBuilder(
      builder: (context, constraints) => OverlayApp(lrcBox: lrcModelBox),
    ),
  );
}
```

**Pragma**: `@pragma('vm:entry-point')` — Required for native code to invoke this function

**Location**: `lib/apps/overlay/`

**Purpose**: System overlay window for floating lyrics

## Shared Bootstrap

Both apps share the same initialization logic:

```dart
Future<(SharedPreferences, Box<LrcModel>)> bootstrap() async {
  final pref = await SharedPreferences.getInstance();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  Hive.registerAdapters();
  final lrcModelBox = await Hive.openBox<LrcModel>('lrc', path: dir.path);

  return (pref, lrcModelBox);
}
```

**Shared Resources**:

- `SharedPreferences` — App settings
- `Hive Box<LrcModel>` — Lyric database (shared across both apps)

## Main App Architecture

### Structure

**File**: [lib/apps/main/main_app.dart](../../../lib/apps/main/main_app.dart)

```dart
class MainApp extends StatelessWidget {
  const MainApp({required this.pref, required this.lrcBox, super.key});

  final SharedPreferences pref;
  final Box<LrcModel> lrcBox;

  @override
  Widget build(BuildContext context) {
    return MainAppDependency(
      pref: pref,
      lrcBox: lrcBox,
      builder: (context, appRouter) => MainAppListener(
        builder: (context) => MainAppView(appRouter: appRouter),
      ),
    );
  }
}
```

**Pattern**: Dependency → Listener → View

### Dependencies (Main App)

**File**: [lib/apps/main/\_dependency.dart](../../../lib/apps/main/_dependency.dart)

Key dependencies:

- `PreferenceRepo` — Settings persistence
- `LocalDbRepo` — Lyric database access
- `LrclibRepository` — Online lyric search
- `MethodChannelService` — Platform communication
- `ToOverlayMsgService` — Send messages to overlay

**BLoCs**:

- `PermissionBloc` — Permission state
- `PreferenceBloc` — App settings
- `MediaListenerBloc` — Media state from platform
- `MsgToOverlayBloc` — Outgoing messages
- `MsgFromOverlayBloc` — Incoming messages
- `OverlayWindowSettingsBloc` — Window configuration

### Responsibilities

1. **User Interface** — Full navigation, settings, lyric management
2. **Permission Management** — Request and monitor permissions
3. **Lyric Database** — CRUD operations on lyrics
4. **Online Search** — Fetch lyrics from LrcLib API
5. **Overlay Control** — Show/hide overlay, send configuration
6. **Media Listener** — Listen to media state from platform (notifications)

## Overlay App Architecture

### Structure

**File**: [lib/apps/overlay/overlay_app.dart](../../../lib/apps/overlay/overlay_app.dart)

```dart
class OverlayApp extends StatelessWidget {
  const OverlayApp({required this.lrcBox, super.key});

  final Box<LrcModel> lrcBox;

  @override
  Widget build(BuildContext context) {
    return OverlayAppDependency(
      lrcBox: lrcBox,
      builder: (context, appRouter) => OverlayAppListener(
        builder: (context) => OverlayAppView(appRouter: appRouter),
      ),
    );
  }
}
```

**Pattern**: Dependency → Listener → View (same as main app)

### Dependencies (Overlay App)

**File**: [lib/apps/overlay/\_dependency.dart](../../../lib/apps/overlay/_dependency.dart)

Key dependencies:

- `LocalDbRepo` — Lyric database access (read-only, mostly)
- `LrclibRepository` — Online lyric search (if needed)
- `ToMainMsgService` — Send messages to main app
- `LayoutChannelService` — Measure overlay layout

**BLoCs**:

- `OverlayAppBloc` — Overlay app state
- `OverlayWindowBloc` — Window state and configuration
- `MsgFromMainBloc` — Incoming messages from main
- `MsgToMainBloc` — Outgoing messages to main
- `LyricFinderBloc` — Find and display lyrics

### Responsibilities

1. **Floating UI** — Display lyrics on top of other apps
2. **Lyric Sync** — Match lyrics to media position
3. **Minimal Interface** — Distraction-free lyric viewing
4. **Always On Top** — System overlay window
5. **Message Receiver** — Receive configuration from main app

## Inter-App Communication

Communication between main and overlay apps uses **IsolateNameServer** for message passing.

### Main → Overlay

**Service**: `ToOverlayMsgService`

**File**: [lib/services/msg_channels/to_overlay_message_service.dart](../../../lib/services/msg_channels/to_overlay_message_service.dart)

```dart
class ToOverlayMsgService {
  void sendMsg(ToOverlayMsgModel msg) {
    final json = jsonDecode(jsonEncode(msg.toJson()));
    _sendJson(json as Map<String, dynamic>);
  }

  void sendWindowConfig(ToOverlayMsgConfig config) => _sendJson(
    jsonDecode(jsonEncode(config.toJson())) as Map<String, dynamic>,
  );

  void sendMediaState(ToOverlayMsgMediaState mediaState) => _sendJson(
    jsonDecode(jsonEncode(mediaState.toJson())) as Map<String, dynamic>,
  );

  void _sendJson(Map<String, dynamic> json) {
    final overlayPort = IsolateNameServer.lookupPortByName(
      MainOverlayPort.overlayPortName.key,
    );
    if (overlayPort == null) {
      logger.e('Overlay port is null');
    } else {
      overlayPort.send(json);
    }
  }
}
```

**Message Types**:

```dart
@freezed
sealed class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel.config(OverlayWindowConfig config) =
      ToOverlayMsgConfig;

  const factory ToOverlayMsgModel.mediaState(MediaState mediaState) =
      ToOverlayMsgMediaState;

  const factory ToOverlayMsgModel.newLyricSaved() = ToOverlayMsgNewLyricSaved;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
```

### Overlay → Main

**Service**: `ToMainMsgService`

**File**: [lib/services/msg_channels/to_main_msg_service.dart](../../../lib/services/msg_channels/to_main_msg_service.dart)

```dart
class ToMainMsgService {
  void sendMsg(ToMainMsg msg) {
    final json = jsonDecode(jsonEncode(msg.toJson()));

    final mainPort = IsolateNameServer.lookupPortByName(
      MainOverlayPort.mainPortName.key,
    );
    if (mainPort == null) {
      logger.e('Main port is null');
    } else {
      mainPort.send(json);
    }
  }
}
```

**Message Types**:

```dart
@freezed
sealed class ToMainMsg with _$ToMainMsg {
  const factory ToMainMsg.closeOverlay() = CloseOverlay;

  const factory ToMainMsg.measureScreenWidth() = MeasureScreenWidth;

  factory ToMainMsg.fromJson(Map<String, dynamic> json) =>
      _$ToMainMsgFromJson(json);
}
```

## Lifecycle Management

### Main App Lifecycle

1. **Launch** — `main()` initializes Firebase, bootstrap resources
2. **Permission Check** — Redirect to permission screen if needed
3. **Home** — Display home screen with lyric controls
4. **Overlay Control** — Show/hide overlay via platform methods
5. **Settings** — Configure overlay window
6. **Background** — Continue running while overlay is visible

### Overlay App Lifecycle

1. **Launch** — `overlayView()` invoked by native code when overlay is shown
2. **Initialize** — Bootstrap resources, setup message listeners
3. **Display** — Show floating lyric UI
4. **Listen** — Receive media state and configuration from main app
5. **Sync** — Update lyrics based on media position
6. **Close** — Native code destroys overlay when hidden

### Platform Integration

The overlay is managed by **native Android code**:

```kotlin
// Show overlay (invokes overlayView())
overlayManager.show()

// Hide overlay
overlayManager.hide()

// Check if active
val isActive = overlayManager.isActive()
```

**Method Channel**: `com.app.methods/actions`

See [Platform Integration](../../platform-integration/method-channels/SKILL.md) for details.

## Data Sharing

Both apps share the same data layer:

### Hive Box (Lyrics)

```dart
final lrcModelBox = await Hive.openBox<LrcModel>('lrc', path: dir.path);
```

- **Box Name**: `'lrc'`
- **Type**: `Box<LrcModel>`
- **Path**: Application documents directory
- **Access**: Both apps can read/write

**Use Case**:

- Main app: Add, edit, delete lyrics
- Overlay app: Read lyrics for display

### SharedPreferences (Settings)

```dart
final pref = await SharedPreferences.getInstance();
```

- **Main app**: Write settings (theme, language, window config)
- **Overlay app**: Read-only (if needed, but mostly receives config via messages)

## Communication Patterns

### Pattern 1: Configuration Update

**Flow**:

1. User changes overlay window settings in main app
2. Main app updates `PreferenceRepo`
3. `MsgToOverlayBloc` sends `ToOverlayMsgConfig` message
4. Overlay app receives message via `MsgFromMainBloc`
5. `OverlayWindowBloc` updates overlay UI

### Pattern 2: Media State Update

**Flow**:

1. Native Android code detects media state change (notification listener)
2. Event channel streams to main app
3. `MediaListenerBloc` processes media state
4. `MsgToOverlayBloc` sends `ToOverlayMsgMediaState` message
5. Overlay app receives message
6. `LyricFinderBloc` fetches matching lyric
7. Overlay UI displays synchronized lyrics

### Pattern 3: Overlay Close Request

**Flow**:

1. User dismisses overlay (gesture or button)
2. Overlay app sends `ToMainMsg.closeOverlay()` message
3. Main app receives message via `MsgFromOverlayBloc`
4. Main app calls `MethodChannelService.hide()`
5. Native code destroys overlay window

## Best Practices

### 1. Message Serialization

Always use freezed models with JSON serialization for messages:

```dart
@freezed
sealed class ToOverlayMsgModel with _$ToOverlayMsgModel {
  const factory ToOverlayMsgModel.config(OverlayWindowConfig config) =
      ToOverlayMsgConfig;

  factory ToOverlayMsgModel.fromJson(Map<String, dynamic> json) =>
      _$ToOverlayMsgModelFromJson(json);
}
```

**Why**: Type-safe, serializable, pattern-matchable

### 2. Port Name Enum

Define port names in an enum:

```dart
enum MainOverlayPort {
  mainPortName('main_port'),
  overlayPortName('overlay_port');

  const MainOverlayPort(this.key);
  final String key;
}
```

**Why**: Consistent naming, avoids typos

### 3. Error Handling

Always check for null ports:

```dart
final overlayPort = IsolateNameServer.lookupPortByName(
  MainOverlayPort.overlayPortName.key,
);
if (overlayPort == null) {
  logger.e('Overlay port is null');
  return; // Fail gracefully
} else {
  overlayPort.send(json);
}
```

**Why**: Overlay may not be active, prevents crashes

### 4. Shared Data Access

Use repositories to abstract Hive access:

```dart
class LocalDbRepo {
  LocalDbRepo({required Box<LrcModel> lrcBox}) : _lrcBox = lrcBox;

  final Box<LrcModel> _lrcBox;

  LrcModel? getLyric(String title, String artist) {
    return _lrcBox.values.firstWhereOrNull(
      (e) => e.title == title && e.artist == artist,
    );
  }
}
```

**Why**: Consistent access pattern, easier testing

### 5. BLoC Communication

Use BLoCs to handle message sending/receiving:

```dart
// Sending (Main App)
class MsgToOverlayBloc extends Bloc<MsgToOverlayEvent, MsgToOverlayState> {
  MsgToOverlayBloc({required ToOverlayMsgService toOverlayMsgService})
      : _toOverlayMsgService = toOverlayMsgService {
    on<SendConfig>(_onSendConfig);
  }

  final ToOverlayMsgService _toOverlayMsgService;

  void _onSendConfig(SendConfig event, Emitter<MsgToOverlayState> emit) {
    _toOverlayMsgService.sendWindowConfig(
      ToOverlayMsgConfig(config: event.config),
    );
  }
}

// Receiving (Overlay App)
class MsgFromMainBloc extends Bloc<MsgFromMainEvent, MsgFromMainState> {
  MsgFromMainBloc() {
    on<ReceiveMsg>(_onReceiveMsg);
    _setupPortListener();
  }

  void _setupPortListener() {
    final receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      MainOverlayPort.overlayPortName.key,
    );

    receivePort.listen((message) {
      final msg = ToOverlayMsgModel.fromJson(message as Map<String, dynamic>);
      add(ReceiveMsg(msg));
    });
  }

  void _onReceiveMsg(ReceiveMsg event, Emitter<MsgFromMainState> emit) {
    emit(MsgFromMainState.received(event.msg));
  }
}
```

**Why**: Reactive, testable, follows BLoC pattern

## Related Skills

- [Architecture Overview](../SKILL.md) — Overall system architecture
- [State Management](../../state-management/SKILL.md) — BLoC pattern
- [Platform Integration](../../platform-integration/method-channels/SKILL.md) — Method/Event channels
- [Data Persistence](../../data-persistence/hive-storage/SKILL.md) — Hive shared storage

## Summary

The dual-app pattern enables:

- ✅ **Separation of concerns** — Main UI vs Overlay UI
- ✅ **System overlay** — Native Android overlay window
- ✅ **Shared data** — Single source of truth (Hive)
- ✅ **Message passing** — IsolateNameServer communication
- ✅ **Independent lifecycles** — Main can run without overlay, vice versa

**Key Insight**: This pattern is necessary because Android system overlays require a separate Flutter engine instance, making it effectively a separate app within the same project.
