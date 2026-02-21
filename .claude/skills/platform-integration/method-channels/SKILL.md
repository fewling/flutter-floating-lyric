---
name: method-channels
description: Detailed guide to platform integration using Method Channels and Event Channels in Floating Lyric app, covering Flutter-to-native communication, channel patterns, and Android implementation.
license: MIT
---

# Method Channels & Event Channels

This skill provides comprehensive documentation on platform integration using **Method Channels** and **Event Channels** in the Floating Lyric app.

## Overview

The Floating Lyric app uses **platform channels** to communicate between Flutter (Dart) and native Android (Kotlin) code.

### Channel Types

| Channel Type       | Direction        | Use Case                               |
| ------------------ | ---------------- | -------------------------------------- |
| **Method Channel** | Bidirectional    | Call native methods, return results    |
| **Event Channel**  | Native → Flutter | Stream continuous data from native     |
| **Basic Message**  | Bidirectional    | Send simple messages (not used in app) |

### Platform Channels in Floating Lyric

**Method Channels**:

1. `com.app.methods/actions` — Overlay control (show, hide, touch-through)
2. `floating_lyric/permission_method_channel` — Permission checks/requests
3. `com.overlay.methods/layout` — Overlay layout measurements

**Event Channels**:

1. `Floating Lyric Media State Channel` — Media state stream (listening to music players)

## Method Channels

### Pattern

```
┌─────────────────┐                ┌──────────────────┐
│  Flutter (Dart) │                │  Android (Kotlin)│
│                 │                │                  │
│  Service        │  MethodChannel │  MethodCallHandler│
│  ├─ invoke()    │ ─────────────> │  ├─ onMethodCall │
│  ├─ await       │ <───────────── │  └─ result       │
│  └─ result      │                │                  │
└─────────────────┘                └──────────────────┘
```

**Flow**:

1. Flutter calls `channel.invokeMethod('methodName', args)`
2. Android receives call in `onMethodCall(call, result)`
3. Android performs operation
4. Android returns result via `result.success(data)` or `result.error(...)`
5. Flutter receives result (Future resolves)

### Example: Overlay Control

#### Flutter Side

**File**: [lib/services/platform_channels/method_channel_service.dart](../../../lib/services/platform_channels/method_channel_service.dart)

```dart
import 'package:flutter/services.dart';

class MethodChannelService {
  final _channel = const MethodChannel('com.app.methods/actions');

  Future<void> start3rdMusicPlayer() =>
      _channel.invokeMethod('start3rdMusicPlayer');

  Future<bool?> show() {
    return _channel.invokeMethod<bool>('show');
  }

  Future<bool?> hide() {
    return _channel.invokeMethod<bool>('hide');
  }

  Future<bool?> isActive() {
    return _channel.invokeMethod<bool>('isActive');
  }

  Future<bool?> setTouchThru(bool isTouchThru) {
    return _channel.invokeMethod<bool>('setTouchThru', {
      'isTouchThru': isTouchThru,
    });
  }

  Future<bool?> toggleNotiListenerSettings() {
    return _channel.invokeMethod<bool>('toggleNotiListenerSettings');
  }
}
```

**Key Points**:

- `MethodChannel('com.app.methods/actions')` — Unique channel name
- `invokeMethod<T>('methodName', args)` — Calls Android method, returns `Future<T>`
- `args` — Map of arguments (optional)

#### Android Side

**File**: `android/app/src/main/kotlin/com/example/floating_lyric/MainActivity.kt`

```kotlin
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.app.methods/actions")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "show" -> {
                        overlayManager.show()
                        result.success(true)
                    }
                    "hide" -> {
                        overlayManager.hide()
                        result.success(true)
                    }
                    "isActive" -> {
                        result.success(overlayManager.isActive())
                    }
                    "setTouchThru" -> {
                        val isTouchThru = call.argument<Boolean>("isTouchThru") ?: false
                        overlayManager.setTouchThru(isTouchThru)
                        result.success(true)
                    }
                    "toggleNotiListenerSettings" -> {
                        // Open notification listener settings
                        startActivity(Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"))
                        result.success(true)
                    }
                    "start3rdMusicPlayer" -> {
                        // Launch music player
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
```

**Key Points**:

- `setMethodCallHandler { call, result -> ... }` — Handle method calls
- `call.method` — Method name (String)
- `call.argument<T>("key")` — Extract arguments
- `result.success(data)` — Return success with data
- `result.error(code, message, details)` — Return error
- `result.notImplemented()` — Method not found

### Example: Permission Checks

#### Flutter Side

**File**: [lib/services/platform_channels/permission_channel_service.dart](../../../lib/services/platform_channels/permission_channel_service.dart)

```dart
import 'package:flutter/services.dart';

enum _PermissionMethod {
  checkNotificationListenerPermission,
  checkSystemAlertWindowPermission,
  requestNotificationListenerPermission,
  requestSystemAlertWindowPermission,
  start3rdMusicPlayer,
}

class PermissionChannelService {
  static const _channel = MethodChannel(
    'floating_lyric/permission_method_channel',
  );

  Future<bool?> checkNotificationListenerPermission() => _channel.invokeMethod(
    _PermissionMethod.checkNotificationListenerPermission.name,
  );

  Future<bool?> requestNotificationListenerPermission() =>
      _channel.invokeMethod(
        _PermissionMethod.requestNotificationListenerPermission.name,
      );

  Future<bool?> checkSystemAlertWindowPermission() => _channel.invokeMethod(
    _PermissionMethod.checkSystemAlertWindowPermission.name,
  );

  Future<bool?> requestSystemAlertWindowPermission() => _channel.invokeMethod(
    _PermissionMethod.requestSystemAlertWindowPermission.name,
  );

  Future<void> start3rdMusicPlayer() =>
      _channel.invokeMethod(_PermissionMethod.start3rdMusicPlayer.name);
}
```

**Pattern**: Uses enum for method names (type-safe, prevents typos)

#### Android Side

**File**: `android/app/src/main/kotlin/com/example/floating_lyric/features/permissions/PermissionMethodCallHandler.kt`

```kotlin
import io.flutter.plugin.common.MethodChannel

class PermissionMethodCallHandler : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var methodChannel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkNotificationListenerPermission" -> {
                result.success(checkNotificationPermission())
            }
            "requestNotificationListenerPermission" -> {
                requestNotificationPermission()
                result.success(true)
            }
            "checkSystemAlertWindowPermission" -> {
                result.success(Settings.canDrawOverlays(context))
            }
            "requestSystemAlertWindowPermission" -> {
                requestOverlayPermission()
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        private const val CHANNEL = "floating_lyric/permission_method_channel"
    }
}
```

**Key Points**:

- Implements `FlutterPlugin` and `MethodChannel.MethodCallHandler`
- `onAttachedToEngine` — Setup during plugin registration
- `onMethodCall` — Handle incoming calls

### Example: Layout Channel (Overlay)

#### Flutter Side

**File**: [lib/services/platform_channels/layout_channel_service.dart](../../../lib/services/platform_channels/layout_channel_service.dart)

```dart
import 'package:flutter/services.dart';

/// This class is mainly used in the Overlay side
class LayoutChannelService {
  LayoutChannelService() {
    _channel = const MethodChannel(_channelName);
  }

  static const _channelName = 'com.overlay.methods/layout';
  late final MethodChannel _channel;

  Future<void> setLayout(double width, double height) async {
    return _channel.invokeMethod('reportSize', {
      'width': width,
      'height': height,
    });
  }

  Future<bool?> toggleLock(bool isLocked) {
    return _channel.invokeMethod<bool>('toggleLock', {'isLocked': isLocked});
  }
}
```

**Use Case**: Overlay app reports its size to native code for positioning

## Event Channels

### Pattern

```
┌─────────────────┐                ┌──────────────────┐
│  Flutter (Dart) │                │  Android (Kotlin)│
│                 │                │                  │
│  Stream         │  EventChannel  │  StreamHandler   │
│  ├─ listen()    │ <───────────── │  ├─ onListen     │
│  ├─ data        │ <───────────── │  ├─ eventSink    │
│  └─ cancel()    │ ─────────────> │  └─ onCancel     │
└─────────────────┘                └──────────────────┘
```

**Flow**:

1. Flutter listens to `channel.receiveBroadcastStream()`
2. Android sets up `StreamHandler` with `EventSink`
3. Android sends data via `eventSink.success(data)`
4. Flutter receives data in stream listener
5. Flutter cancels → Android `onCancel()` called

### Example: Media State Stream

#### Flutter Side

**File**: [lib/services/event_channels/media_states/media_state_event_channel.dart](../../../lib/services/event_channels/media_states/media_state_event_channel.dart)

```dart
// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/services.dart';

import '../../../models/media_state.dart';

const _channelName = 'Floating Lyric Media State Channel';
const _mediaStateChannel = EventChannel(_channelName);

final mediaStateStream = _mediaStateChannel.receiveBroadcastStream().map((
  event,
) {
  return (event as List<dynamic>).map((e) {
    final mediaPlayerName = e['mediaPlayerName'] as String;
    final title = e['title'] as String;
    final artist = e['artist'] as String;
    final album = e['album'] as String;
    final position = e['position'] as double;
    final duration = e['duration'] as double;
    final isPlaying = e['isPlaying'] as bool;

    return MediaState(
      mediaPlayerName: mediaPlayerName,
      title: title,
      artist: artist,
      album: album,
      position: position,
      duration: duration,
      isPlaying: isPlaying,
    );
  }).toList();
});
```

**Key Points**:

- `EventChannel('channelName')` — Create channel
- `receiveBroadcastStream()` — Returns `Stream<dynamic>`
- `.map(...)` — Transform raw data to Dart models
- `as List<dynamic>` — Type casting from native data

#### Android Side

**File**: `android/app/src/main/kotlin/com/example/floating_lyric/MainActivity.kt`

```kotlin
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private lateinit var mediaStateEventChannel: EventChannel
    private val mediaStateEventStreamHandler = MediaStateEventStreamHandler()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mediaStateEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STATE_EVENT_CHANNEL)

        mediaStateEventChannel.setStreamHandler(mediaStateEventStreamHandler)
    }

    companion object {
        const val MEDIA_STATE_EVENT_CHANNEL = "Floating Lyric Media State Channel"
    }
}
```

**StreamHandler**:

```kotlin
class MediaStateEventStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        // Start listening to media changes
        startMediaListener()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        // Stop listening
        stopMediaListener()
    }

    fun sendMediaState(mediaStateList: List<Map<String, Any>>) {
        eventSink?.success(mediaStateList)
    }
}
```

**Flow**:

1. Flutter subscribes → `onListen()` called
2. Android stores `eventSink`
3. Android detects media change → calls `eventSink.success(data)`
4. Flutter receives data in stream
5. Flutter cancels → `onCancel()` called

### Media State Broadcast Receiver

**File**: `android/app/src/main/kotlin/com/example/floating_lyric/features/media_tracker/MediaStateBroadcastReceiver.kt`

```kotlin
import io.flutter.plugin.common.EventChannel

class MediaStateBroadcastReceiver(private val eventSink: EventChannel.EventSink) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val mediaStateList = extractMediaStateFromIntent(intent)
        eventSink.success(mediaStateList)
    }

    private fun extractMediaStateFromIntent(intent: Intent): List<Map<String, Any>> {
        // Parse media metadata from notification
        val title = intent.getStringExtra("title") ?: ""
        val artist = intent.getStringExtra("artist") ?: ""
        // ... extract other fields

        return listOf(
            mapOf(
                "mediaPlayerName" to playerName,
                "title" to title,
                "artist" to artist,
                "album" to album,
                "position" to position,
                "duration" to duration,
                "isPlaying" to isPlaying,
            )
        )
    }
}
```

**Use Case**: Listens to music player notifications, extracts metadata, sends to Flutter

## Channel Naming Conventions

### Best Practices

1. **Unique Names** — Avoid collisions with other plugins
2. **Reverse Domain** — Use package identifier prefix
3. **Descriptive** — Indicate purpose

**Examples**:

```dart
// ✅ Good
'com.app.methods/actions'
'floating_lyric/permission_method_channel'
'Floating Lyric Media State Channel'

// ❌ Bad (too generic)
'channel'
'methods'
'events'
```

### Conventions in Floating Lyric

| Channel Name                               | Type   | Purpose                    |
| ------------------------------------------ | ------ | -------------------------- |
| `com.app.methods/actions`                  | Method | Overlay control            |
| `floating_lyric/permission_method_channel` | Method | Permission checks/requests |
| `com.overlay.methods/layout`               | Method | Overlay layout             |
| `Floating Lyric Media State Channel`       | Event  | Media state stream         |

## Data Types

### Supported Types

| Dart Type              | Android Type       |
| ---------------------- | ------------------ |
| `null`                 | `null`             |
| `bool`                 | `Boolean`          |
| `int`                  | `Int`, `Long`      |
| `double`               | `Double`           |
| `String`               | `String`           |
| `Uint8List`            | `ByteArray`        |
| `Int32List`            | `IntArray`         |
| `List<dynamic>`        | `List<Any>`        |
| `Map<String, dynamic>` | `Map<String, Any>` |

### Complex Data

**Flutter**:

```dart
final data = {
  'title': 'Song Title',
  'artist': 'Artist Name',
  'duration': 180.5,
  'isPlaying': true,
};
await channel.invokeMethod('sendData', data);
```

**Android**:

```kotlin
override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
        "sendData" -> {
            val title = call.argument<String>("title")
            val artist = call.argument<String>("artist")
            val duration = call.argument<Double>("duration")
            val isPlaying = call.argument<Boolean>("isPlaying")
            // Use data
            result.success(null)
        }
    }
}
```

## Error Handling

### Flutter Side

```dart
try {
  final result = await _channel.invokeMethod<bool>('show');
  if (result == true) {
    print('Overlay shown successfully');
  }
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  print('Details: ${e.details}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### Android Side

```kotlin
override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    try {
        when (call.method) {
            "show" -> {
                if (canShowOverlay()) {
                    overlayManager.show()
                    result.success(true)
                } else {
                    result.error(
                        "NO_PERMISSION",
                        "Overlay permission not granted",
                        null
                    )
                }
            }
            else -> result.notImplemented()
        }
    } catch (e: Exception) {
        result.error("EXCEPTION", e.message, e.stackTrace.toString())
    }
}
```

**Error Codes** (custom):

- `"NO_PERMISSION"` — Permission denied
- `"EXCEPTION"` — Unexpected error
- `"INVALID_ARGUMENT"` — Bad argument

## Testing

### Unit Testing Method Channels

**File**: `test/services/method_channel_service_test.dart`

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.app.methods/actions');

  setUp(() {
    // Mock method call handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'show':
          return true;
        case 'hide':
          return true;
        case 'isActive':
          return false;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('show() returns true', () async {
    final result = await channel.invokeMethod<bool>('show');
    expect(result, true);
  });

  test('isActive() returns false', () async {
    final result = await channel.invokeMethod<bool>('isActive');
    expect(result, false);
  });
}
```

### Unit Testing Event Channels

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = EventChannel('Floating Lyric Media State Channel');

  test('mediaStateStream emits data', () async {
    // Setup mock stream
    final controller = StreamController<dynamic>();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(channel, MockStreamHandler(controller));

    final stream = channel.receiveBroadcastStream();

    // Emit test data
    controller.add([
      {
        'mediaPlayerName': 'Test Player',
        'title': 'Test Song',
        'artist': 'Test Artist',
      }
    ]);

    // Verify
    expectLater(stream, emits(anything));

    await controller.close();
  });
}

class MockStreamHandler extends MockStreamHandlerPlatform {
  final StreamController<dynamic> controller;

  MockStreamHandler(this.controller);

  @override
  Stream<dynamic> onListen(Object? arguments) => controller.stream;

  @override
  void onCancel(Object? arguments) {}
}
```

## Best Practices

### 1. Service Abstraction

Always wrap channels in service classes:

```dart
// ✅ Good
class MethodChannelService {
  final _channel = const MethodChannel('com.app.methods/actions');

  Future<bool?> show() => _channel.invokeMethod<bool>('show');
}

// ❌ Bad (direct usage in BLoC)
class MyBloc extends Bloc<MyEvent, MyState> {
  final channel = MethodChannel('com.app.methods/actions');

  void _onEvent() async {
    await channel.invokeMethod('show'); // Direct usage
  }
}
```

**Why**: Testability, encapsulation, easier to mock.

### 2. Type-Safe Method Names

Use enums for method names:

```dart
enum OverlayMethod {
  show,
  hide,
  isActive,
}

Future<bool?> show() => _channel.invokeMethod<bool>(OverlayMethod.show.name);
```

**Why**: Prevents typos, IDE autocomplete, refactor-safe.

### 3. Null Safety

Always handle null returns:

```dart
final result = await _channel.invokeMethod<bool>('show');
if (result == true) {
  // Success
} else {
  // Null or false
}
```

### 4. Error Handling

Wrap in try-catch:

```dart
try {
  await _channel.invokeMethod('show');
} on PlatformException catch (e) {
  logger.e('Platform error: ${e.message}');
} catch (e) {
  logger.e('Unexpected error: $e');
}
```

### 5. Stream Cleanup

Cancel event stream subscriptions:

```dart
StreamSubscription? _subscription;

void startListening() {
  _subscription = mediaStateStream.listen((states) {
    // Handle media state
  });
}

void stopListening() {
  _subscription?.cancel();
}
```

## Common Pitfalls

### 1. Channel Name Mismatch

**Problem**: Flutter and Android use different channel names

```dart
// Flutter
const channel = MethodChannel('com.app.methods/actions');

// Android
MethodChannel(binaryMessenger, "com.app.methods/action") // Missing 's'
```

**Solution**: Use constants, share naming

### 2. Forgetting to Call result

**Problem**: Android doesn't call `result.success()` or `result.error()`

```kotlin
// ❌ Bad
override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
        "show" -> overlayManager.show() // No result!
    }
}
```

**Solution**: Always call `result.success()`, `result.error()`, or `result.notImplemented()`

```kotlin
// ✅ Good
override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
        "show" -> {
            overlayManager.show()
            result.success(true)
        }
        else -> result.notImplemented()
    }
}
```

### 3. Type Casting Errors

**Problem**: Incorrect type casting from dynamic

```dart
// ❌ Bad
final event = event as Map<String, String>; // May crash if contains int/double

// ✅ Good
final event = event as Map<String, dynamic>;
final title = event['title'] as String;
final position = event['position'] as double;
```

### 4. Memory Leaks (Event Channels)

**Problem**: Not canceling stream subscriptions

**Solution**: Always cancel in dispose:

```dart
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

## Platform-Specific Features

### Android System Overlay

The overlay window is a system-level feature requiring special permissions:

**Permission Check**:

```kotlin
Settings.canDrawOverlays(context)
```

**Request Permission**:

```kotlin
val intent = Intent(
    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
    Uri.parse("package:$packageName")
)
startActivityForResult(intent, REQUEST_CODE)
```

**Flutter Usage**:

```dart
final hasPermission = await permissionChannelService.checkSystemAlertWindowPermission();
if (hasPermission != true) {
  await permissionChannelService.requestSystemAlertWindowPermission();
}
```

### Notification Listener

Listens to music player notifications for media state:

**Permission Check**:

```kotlin
val enabledNotificationListeners = Settings.Secure.getString(
    contentResolver,
    "enabled_notification_listeners"
)
enabledNotificationListeners?.contains(packageName) == true
```

**Request Permission**:

```kotlin
startActivity(Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"))
```

## Related Skills

- [Dual-App Pattern](../../architecture/dual-app-pattern/SKILL.md) — Platform integration in dual apps
- [State Management](../../state-management/SKILL.md) — Using channel data in BLoCs

## Summary

Platform integration in Floating Lyric:

- ✅ **Method Channels** — Bidirectional RPC calls (overlay control, permissions)
- ✅ **Event Channels** — Native-to-Flutter streams (media state)
- ✅ **Service abstraction** — Wrap channels in service classes
- ✅ **Type safety** — Enums for method names, proper type casting
- ✅ **Error handling** — Try-catch on Flutter, result.error() on Android
- ✅ **Testability** — Mock channels in unit tests

**Key Files**:

- [lib/services/platform_channels/method_channel_service.dart](../../../lib/services/platform_channels/method_channel_service.dart) — Overlay control
- [lib/services/platform_channels/permission_channel_service.dart](../../../lib/services/platform_channels/permission_channel_service.dart) — Permission management
- [lib/services/event_channels/media_states/media_state_event_channel.dart](../../../lib/services/event_channels/media_states/media_state_event_channel.dart) — Media state stream
- `android/app/src/main/kotlin/com/example/floating_lyric/MainActivity.kt` — Android channel setup

**Platform Channels Documentation**: https://docs.flutter.dev/platform-integration/platform-channels
