---
name: code-generation
description: Code generation overview in the Floating Lyric app. Covers freezed, json_serializable, build_runner, and l10n generation. Use this as an entry point to understanding code generation workflows in the app.
license: MIT
---

# Code Generation

This skill provides an overview of code generation in the Floating Lyric app, including freezed models, JSON serialization, localization, and build_runner workflows.

## Overview

The Floating Lyric app relies heavily on code generation for:

- **Immutable data classes** (freezed)
- **JSON serialization** (json_serializable)
- **Localization** (flutter_localizations)
- **Type-safe models** for BLoC states, events, and domain models

## Code Generation Tools

### Core Packages

```yaml
dependencies:
  freezed_annotation: ^3.2.3
  json_annotation: ^4.10.0

dev_dependencies:
  build_runner: ^2.9.0
  freezed: ^3.2.3
  json_serializable: ^6.11.1
```

### Tool Overview

| Tool                    | Purpose                            | Used For                         |
| ----------------------- | ---------------------------------- | -------------------------------- |
| `freezed`               | Immutable classes with union types | BLoC states/events, models, DTOs |
| `json_serializable`     | JSON ↔ Dart conversion             | API models, Hive models          |
| `build_runner`          | Code generation orchestrator       | Run all generators               |
| `flutter_localizations` | Localization generation            | Multi-language support           |

## Generated File Extensions

| Extension                 | Tool                  | Purpose         | Should Commit?              |
| ------------------------- | --------------------- | --------------- | --------------------------- |
| `.freezed.dart`           | freezed               | Data classes    | ❌ No (add to `.gitignore`) |
| `.g.dart`                 | json_serializable     | JSON converters | ❌ No (add to `.gitignore`) |
| `app_localizations*.dart` | flutter_localizations | L10n classes    | ❌ No (generated from ARB)  |

**.gitignore**:

```gitignore
# Code generation
*.freezed.dart
*.g.dart
lib/gen/

# Localization
lib/l10n/*.dart
!lib/l10n/*.arb
```

## 1. Freezed (Immutable Classes)

### What is Freezed?

Freezed generates:

- **Immutable data classes**
- **copyWith** methods
- **== and hashCode** overrides
- **toString** method
- **Union types** (sealed classes)
- **Pattern matching** support

### Usage Patterns

#### Basic Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
    @Default(false) bool isVerified,
  }) = _User;
}
```

#### Model with JSON Serialization

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_model.freezed.dart';
part 'lyric_model.g.dart';  // For JSON

@freezed
class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
    String? artist,
    @JsonKey(name: 'lyric_lines') List<String>? lyricLines,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
```

#### Union Types (Sealed Classes)

```dart
@freezed
sealed class LyricListEvent with _$LyricListEvent {
  const factory LyricListEvent.started() = _Started;
  const factory LyricListEvent.searchUpdated(String searchTerm) = _SearchUpdated;
  const factory LyricListEvent.deleteRequested(LrcModel lyric) = _DeleteRequested;
}
```

#### BLoC State

```dart
@freezed
sealed class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcModel>[]) List<LrcModel> lyrics,
    @Default(Status.initial) Status status,
    String? errorMessage,
  }) = _LyricListState;
}
```

See [Freezed Models](freezed-models/SKILL.md) for detailed patterns.

### When to Use Freezed

✅ **BLoC Events** - Union types for different events  
✅ **BLoC States** - Immutable state with copyWith  
✅ **Domain Models** - Data classes (User, Settings, etc.)  
✅ **DTOs** - Data transfer objects  
✅ **Route Parameters** - Type-safe navigation params  
✅ **API Responses** - Response models

❌ **Don't use for**:

- Stateful widgets (need mutable state)
- Controllers (need mutation)
- Simple enums (use regular enum)

## 2. JSON Serialization

### What is json_serializable?

Generates:

- **fromJson** constructors
- **toJson** methods
- **Type converters** for custom types
- **Field renaming** (snake_case ↔ camelCase)

### With Freezed

```dart
@freezed
class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    @JsonKey(name: 'song_title') String? title,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}

// Custom converter
DateTime? _dateFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateToJson(DateTime? date) => date?.toIso8601String();
```

### Field Annotations

```dart
@JsonKey(name: 'api_field_name')       // Rename field
@JsonKey(defaultValue: 'Unknown')      // Default if null
@JsonKey(includeIfNull: false)         // Omit if null
@JsonKey(ignore: true)                 // Don't serialize
@JsonKey(fromJson: customFromJson)     // Custom deserializer
@JsonKey(toJson: customToJson)         // Custom serializer
```

## 3. Build Runner

### What is build_runner?

`build_runner` is the orchestrator that runs all code generators in a Dart project.

#### One-Time Build

```bash
# Generate all files
fvm dart run build_runner build

# Delete existing and regenerate
fvm dart run build_runner build -d
```

#### Watch Mode

```bash
# Auto-regenerate on file changes
fvm dart run build_runner watch

# With delete conflicts
fvm dart run build_runner watch -d
```

#### Clean Generated Files

```bash
fvm dart run build_runner clean
```

### When to Run Build Runner

✅ **After creating/modifying**:

- Freezed classes
- JSON serializable models
- Any file with code generation annotations

✅ **When you see errors**:

- "Part not found"
- "Undefined class: \_$ClassName"
- "fromJson method not found"

✅ **After**:

- Changing dependencies
- Pulling code from Git
- Switching branches

### Generated File Types

```
lib/models/
├── user.dart                    # Source file
├── user.freezed.dart            # Generated by freezed
└── user.g.dart                  # Generated by json_serializable

lib/blocs/lyric_list/
├── lyric_list_event.dart        # Source
├── lyric_list_event.freezed.dart
├── lyric_list_state.dart        # Source
├── lyric_list_state.freezed.dart
└── lyric_list_bloc.dart         # Source (no generation)
```

## 4. Localization (L10n) Generation

### Setup

**pubspec.yaml**:

```yaml
flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

**l10n.yaml**:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### ARB Files

**lib/l10n/app_en.arb** (English):

```json
{
  "@@locale": "en",
  "appTitle": "Floating Lyric",
  "@appTitle": {
    "description": "The application title"
  },
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

**lib/l10n/app_zh.arb** (Chinese):

```json
{
  "@@locale": "zh",
  "appTitle": "悬浮歌词",
  "welcomeMessage": "欢迎，{name}！"
}
```

### Generated Files

After running `flutter gen-l10n` or `flutter build`:

```
lib/gen/
└── l10n/
    ├── app_localizations.dart           # Main class
    ├── app_localizations_en.dart        # English
    └── app_localizations_zh.dart        # Chinese
```

### Usage in App

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePage(),
    );
  }
}

// In widgets
Text(AppLocalizations.of(context)!.appTitle)
Text(AppLocalizations.of(context)!.welcomeMessage('John'))
```

### Generate L10n

```bash
# Automatically generated during build
fvm flutter build apk

# Or manually
fvm flutter gen-l10n
```

## Code Generation Workflow

### Initial Setup

```bash
# 1. Install dependencies
fvm dart get

# 2. Generate all code
fvm dart run build_runner build -d

# 3. Generate localizations (if needed)
fvm flutter gen-l10n
```

### Daily Development

```bash
# Option 1: Watch mode (recommended for active development)
fvm dart run build_runner watch -d

# Option 2: Manual rebuild (when needed)
fvm dart run build_runner build -d
```

### After Git Pull

```bash
# Regenerate all files
fvm flutter clean
fvm dart get
fvm dart run build_runner build -d
```

## File Organization

### Project Structure

```
lib/
├── models/
│   ├── lyric_model.dart
│   ├── lyric_model.freezed.dart      # Generated
│   ├── lyric_model.g.dart            # Generated
│   ├── media_state.dart
│   ├── media_state.freezed.dart      # Generated
│   └── media_state.g.dart            # Generated
│
├── blocs/
│   └── lyric_list/
│       ├── lyric_list_event.dart
│       ├── lyric_list_event.freezed.dart    # Generated
│       ├── lyric_list_state.dart
│       ├── lyric_list_state.freezed.dart    # Generated
│       └── lyric_list_bloc.dart
│
├── routes/
│   ├── main_route_path_params.dart
│   └── main_route_path_params.freezed.dart  # Generated
│
├── l10n/
│   ├── app_en.arb                    # Source
│   └── app_zh.arb                    # Source
│
└── gen/
    └── l10n/
        ├── app_localizations.dart         # Generated
        ├── app_localizations_en.dart      # Generated
        └── app_localizations_zh.dart      # Generated
```

## Best Practices

### DO

✅ **Add generated files to .gitignore**  
✅ **Run watch mode during development**  
✅ **Use freezed for immutable classes**  
✅ **Use json_serializable for API models**  
✅ **Generate after pulling code**  
✅ **Document custom converters**  
✅ **Use @JsonKey annotations** for field mapping  
✅ **Keep ARB files in sync** across locales

### DON'T

❌ **Don't commit generated files** (unless necessary)  
❌ **Don't edit generated files manually**  
❌ **Don't forget `part` directive** in source files  
❌ **Don't mix mutable and immutable patterns**  
❌ **Don't ignore build_runner errors**  
❌ **Don't run multiple build_runner instances**  
❌ **Don't forget factory constructors** for freezed

## Code Generation Checklist

When creating a new model:

- [ ] Add freezed annotation: `@freezed`
- [ ] Add part directive: `part 'file.freezed.dart';`
- [ ] Add JSON part if needed: `part 'file.g.dart';`
- [ ] Create factory constructor
- [ ] Add fromJson/toJson if using JSON
- [ ] Run build_runner: `fvm dart run build_runner build`
- [ ] Verify generated files created
- [ ] Test serialization (if applicable)

## Performance Tips

### Parallel Generation

Watch mode runs incrementally and is faster for iterative development:

```bash
fvm dart run build_runner watch -d
```

## Common Patterns in Floating Lyric

### 1. BLoC Event

```dart
@freezed
sealed class LyricListEvent with _$LyricListEvent {
  const factory LyricListEvent.started() = _Started;
  const factory LyricListEvent.searchUpdated(String searchTerm) = _SearchUpdated;
}
```

### 2. BLoC State

```dart
@freezed
sealed class LyricListState with _$LyricListState {
  const factory LyricListState({
    @Default(<LrcModel>[]) List<LrcModel> lyrics,
    @Default(Status.initial) Status status,
  }) = _LyricListState;
}
```

### 3. Model with JSON

```dart
@freezed
class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
```

### 4. Route Parameters

```dart
@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.lyricDetail({
    required String id,
  }) = _LyricDetailPathParams;
}
```

## Related Skills

- [Freezed Models](freezed-models/SKILL.md) - Detailed freezed patterns
- [Build Commands](build-commands/SKILL.md) - build_runner reference
- [BLoC Structure](../state-management/bloc-structure/SKILL.md) - Using freezed for events/states
- [Code Conventions](../development/code-conventions/SKILL.md) - File naming and organization

## Resources

- [Freezed Documentation](https://pub.dev/packages/freezed)
- [json_serializable Documentation](https://pub.dev/packages/json_serializable)
- [build_runner Documentation](https://pub.dev/packages/build_runner)
- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
