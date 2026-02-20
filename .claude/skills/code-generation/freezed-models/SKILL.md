---
name: freezed-models
description: Creating immutable data models with freezed package in the Floating Lyric app. Covers basic models, JSON serialization, union types, custom methods, and code generation. Use this when creating models, BLoC states, or events.
license: MIT
---

# Freezed Models

This skill documents how to create immutable data models using the freezed package in the Floating Lyric app.

## What is Freezed?

**Freezed** is a code generation package that creates:

- Immutable classes
- `copyWith` method for updates
- Value equality (`==` and `hashCode`)
- `toString` method
- Union types (sealed classes)
- JSON serialization integration

## Basic Model Structure

### Simple Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_model.freezed.dart';
part 'lyric_model.g.dart';

@freezed
@immutable
sealed class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? fileName,
    String? content,
    String? title,
    String? artist,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
```

**Key Elements**:

1. **Imports**: `freezed_annotation`
2. **Part directives**: `.freezed.dart` and `.g.dart`
3. **Annotations**: `@freezed`, optionally `@immutable`
4. **Sealed class**: `sealed class` for pattern matching
5. **Mixin**: `with _$ModelName`
6. **Factory constructor**: Using `const factory`
7. **fromJson factory**: For JSON deserialization

### Required vs Optional Fields

```dart
@freezed
sealed class MyModel with _$MyModel {
  const factory MyModel({
    // Required field - no default value
    required String id,
    required String name,

    // Optional field - nullable
    String? description,
    int? count,

    // Optional field with default value
    @Default(false) bool isActive,
    @Default(<String>[]) List<String> tags,
    @Default(0) int retryCount,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

## JSON Serialization

### Basic Serialization

```dart
@freezed
sealed class MediaState with _$MediaState {
  const factory MediaState({
    required String mediaPlayerName,
    required String title,
    required String artist,
    required String album,
    required double position,
    required double duration,
    required bool isPlaying,
  }) = _MediaState;

  factory MediaState.fromJson(Map<String, dynamic> json) =>
      _$MediaStateFromJson(json);
}
```

**Usage**:

```dart
// To JSON
final mediaState = MediaState(/* ... */);
final json = mediaState.toJson();

// From JSON
final mediaState = MediaState.fromJson(jsonData);
```

### Custom JSON Keys

```dart
@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(name: 'user_id') required String id,
    @JsonKey(name: 'user_name') required String name,
    @JsonKey(name: 'email_address') String? email,

    // Exclude from JSON
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? localCache,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

### Custom JSON Converters

For enum or complex types:

```dart
@freezed
sealed class OverlayWindowConfig with _$OverlayWindowConfig {
  const factory OverlayWindowConfig({
    @JsonKey(fromJson: appLocaleFromJson, toJson: appLocaleToJson)
    @Default(AppLocale.english)
    AppLocale locale,

    @JsonKey(fromJson: animationModeFromJson, toJson: animationModeToJson)
    @Default(AnimationMode.fadeIn)
    AnimationMode animationMode,

    @Default(false) bool isLight,
    double? opacity,
  }) = _OverlayWindowConfig;

  factory OverlayWindowConfig.fromJson(Map<String, dynamic> json) =>
      _$OverlayWindowConfigFromJson(json);
}

// Custom converter functions
AppLocale appLocaleFromJson(String json) {
  return AppLocale.values.firstWhere(
    (e) => e.name == json,
    orElse: () => AppLocale.english,
  );
}

String appLocaleToJson(AppLocale locale) => locale.name;
```

## Union Types (Sealed Classes)

Union types represent "one of several" cases:

### Event Union Types

```dart
@freezed
sealed class LyricListEvent with _$LyricListEvent {
  const factory LyricListEvent.started() = _Started;
  const factory LyricListEvent.searchUpdated(String searchTerm) = _SearchUpdated;
  const factory LyricListEvent.deleteRequested(LrcModel lyric) = _DeleteRequested;
  const factory LyricListEvent.deleteAllRequested() = _DeleteAllRequested;
}
```

**Usage with Pattern Matching**:

```dart
// Exhaustive switch
final result = switch (event) {
  _Started() => handleStarted(),
  _SearchUpdated(:final searchTerm) => handleSearch(searchTerm),
  _DeleteRequested(:final lyric) => handleDelete(lyric),
  _DeleteAllRequested() => handleDeleteAll(),
};

// Or with event handler
on<LyricListEvent>(
  (event, emit) => switch (event) {
    _Started() => _onStarted(event, emit),
    _SearchUpdated() => _onSearchUpdated(event, emit),
    _DeleteRequested() => _onDeleteRequested(event, emit),
    _DeleteAllRequested() => _onDeleteAllRequested(event, emit),
  },
)
```

### State Union Types

```dart
@freezed
sealed class LoadingState with _$LoadingState {
  const factory LoadingState.initial() = _Initial;
  const factory LoadingState.loading() = _Loading;
  const factory LoadingState.loaded(List<Item> items) = _Loaded;
  const factory LoadingState.error(String message) = _Error;
}
```

**Usage**:

```dart
// Pattern matching in UI
return switch (state) {
  _Initial() => const Text('Press button to load'),
  _Loading() => const CircularProgressIndicator(),
  _Loaded(:final items) => ListView(children: items.map(...)),
  _Error(:final message) => Text('Error: $message'),
};

// Or with mapOrNull
state.maybeWhen(
  loaded: (items) => ListView(...),
  error: (message) => ErrorWidget(message),
  orElse: () => const SizedBox(),
);
```

### Path Parameters Union Types

```dart
@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.localLyricDetail({
    required String id,
  }) = LocalLyricDetailPathParams;

  const factory MainRoutePathParams.userProfile({
    required String userId,
  }) = UserProfilePathParams;

  factory MainRoutePathParams.fromJson(Map<String, dynamic> json) =>
      _$MainRoutePathParamsFromJson(json);
}
```

## Custom Methods and Getters

### Extension Methods (Recommended)

```dart
@freezed
sealed class MediaState with _$MediaState {
  const factory MediaState({
    required String title,
    required String artist,
    required double position,
    required double duration,
    required bool isPlaying,
  }) = _MediaState;

  factory MediaState.fromJson(Map<String, dynamic> json) =>
      _$MediaStateFromJson(json);
}

// Add custom methods via extension
extension MediaStateExtension on MediaState {
  bool isSameMedia(MediaState other) =>
      title == other.title &&
      artist == other.artist &&
      duration == other.duration;

  String get positionStr => Duration(
        seconds: position.toInt(),
      ).toString().split('.').first.padLeft(8, '0');

  String get durationStr => Duration(
        seconds: duration.toInt(),
      ).toString().split('.').first.padLeft(8, '0');

  double get progress => duration > 0 ? position / duration : 0;
}
```

**Usage**:

```dart
final state = MediaState(/* ... */);
print(state.positionStr);  // "00:01:23"
print(state.progress);     // 0.456
```

### Private Constructor for Custom Getters (Alternative)

```dart
@freezed
sealed class MyModel with _$MyModel {
  const MyModel._();  // Private constructor

  const factory MyModel({
    required String firstName,
    required String lastName,
  }) = _MyModel;

  // Custom getter
  String get fullName => '$firstName $lastName';

  // Custom method
  bool hasName(String name) =>
      firstName.contains(name) || lastName.contains(name);

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Note**: Private constructor prevents using `const` at call site.

## Default Values

### Primitive Types

```dart
@freezed
sealed class Config with _$Config {
  const factory Config({
    @Default(true) bool isEnabled,
    @Default(0) int count,
    @Default(0.0) double value,
    @Default('') String text,
  }) = _Config;
}
```

### Collections

```dart
@freezed
sealed class ListModel with _$ListModel {
  const factory ListModel({
    @Default(<String>[]) List<String> items,
    @Default(<int, String>{}) Map<int, String> lookup,
    @Default({}) Set<String> uniqueItems,
  }) = _ListModel;
}
```

### Complex Types

```dart
@freezed
sealed class Settings with _$Settings {
  const factory Settings({
    @Default(Duration(seconds: 30)) Duration timeout,
    @Default(AppLocale.english) AppLocale locale,
    @Default(Status.initial) Status status,
  }) = _Settings;
}
```

## Copying and Updating

### Basic copyWith

```dart
final user = User(id: '1', name: 'John', email: 'john@example.com');

// Update single field
final updated = user.copyWith(name: 'Jane');

// Update multiple fields
final updated2 = user.copyWith(
  name: 'Jane',
  email: 'jane@example.com',
);

// Set nullable field to null
final updated3 = user.copyWith(email: null);
```

### Nested copyWith

```dart
final state = MyState(
  user: User(id: '1', name: 'John'),
  settings: Settings(locale: AppLocale.english),
);

// Update nested object
final newState = state.copyWith(
  user: state.user.copyWith(name: 'Jane'),
);
```

## Best Practices

### DO

✅ **Use `@freezed` for all models, states, events**  
✅ **Use `sealed class` for exhaustive pattern matching**  
✅ **Add `part` directives for generated files**  
✅ **Use `@Default()` for non-nullable fields with default values**  
✅ **Use extension methods for custom logic**  
✅ **Use union types for states with distinct cases**  
✅ **Add JSON serialization when needed**  
✅ **Use meaningful type names**

### DON'T

❌ **Don't forget to run code generation** after changes  
❌ **Don't use mutable collections** (List, Map, Set) - they'll still be mutable  
❌ **Don't modify generated files**  
❌ **Don't use private constructor** unless you need custom methods  
❌ **Don't forget `const factory`**  
❌ **Don't use freezed for simple value classes** (use records instead)

## Code Generation Commands

After creating or modifying freezed models:

```bash
# One-time generation
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Short version
fvm flutter pub run build_runner build -d

# Watch mode (auto-regenerate)
fvm flutter pub run build_runner watch -d

# Clean and rebuild
fvm flutter pub run build_runner clean
fvm flutter pub run build_runner build -d
```

See [Build Commands](../build-commands/SKILL.md) for details.

## Common Patterns in Floating Lyric

### 1. Data Model

```dart
@freezed
sealed class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
    String? artist,
    String? content,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
```

### 2. BLoC State

```dart
@freezed
sealed class FeatureState with _$FeatureState {
  const factory FeatureState({
    @Default(<Item>[]) List<Item> items,
    @Default(Status.initial) Status status,
    String? errorMessage,
  }) = _FeatureState;
}
```

### 3. BLoC Event (Union)

```dart
@freezed
sealed class FeatureEvent with _$FeatureEvent {
  const factory FeatureEvent.started() = _Started;
  const factory FeatureEvent.itemAdded(Item item) = _ItemAdded;
  const factory FeatureEvent.itemDeleted(String id) = _ItemDeleted;
}
```

### 4. Route Parameters

```dart
@freezed
sealed class RouteParams with _$RouteParams {
  const factory RouteParams.detail({
    required String id,
  }) = DetailParams;

  factory RouteParams.fromJson(Map<String, dynamic> json) =>
      _$RouteParamsFromJson(json);
}
```

## Troubleshooting

### Issue: Build fails with conflicts

**Solution**:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Generated file not found

**Solution**:

1. Check `part` directive matches filename
2. Run build_runner
3. Check for errors in pub run output

### Issue: JSON serialization not working

**Solution**:

1. Add `.g.dart` part directive
2. Add `factory fromJson` method
3. Add `json_serializable` to `dev_dependencies`
4. Run build_runner

### Issue: Cannot use const constructor

**Solution**:
Don't use private constructor `const MyModel._()` if you need const.

## Related Skills

- [BLoC Structure](../../state-management/bloc-structure/SKILL.md) - Using freezed for events/states
- [Build Commands](../build-commands/SKILL.md) - Code generation workflow
- [Route Definition](../../routing-navigation/route-definition/SKILL.md) - Freezed path parameters
- [Code Conventions](../../development/code-conventions/SKILL.md) - File naming
