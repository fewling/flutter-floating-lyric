---
name: code-conventions
description: Code conventions and style guide for the Floating Lyric app, including naming conventions, file organization, Dart linting rules, and project structure patterns. Use this skill when writing new code or refactoring to ensure consistency.
license: MIT
---

# Code Conventions

This skill documents the code conventions, naming patterns, file organization, and style guide for the Floating Lyric Flutter app.

## File & Folder Naming

### General Rules

- **Files**: Use `snake_case` for all file names
  - ✅ `lyric_list_bloc.dart`
  - ✅ `fetch_online_lrc_form.dart`
  - ❌ `LyricListBloc.dart`
  - ❌ `fetchOnlineLrcForm.dart`

- **Folders**: Use `snake_case` for all folder names
  - ✅ `lyric_list/`
  - ✅ `overlay_window_settings/`
  - ❌ `LyricList/`
  - ❌ `overlayWindowSettings/`

### File Naming Patterns

| Type       | Pattern                                        | Example                                        |
| ---------- | ---------------------------------------------- | ---------------------------------------------- |
| BLoC       | `{feature}_bloc.dart`                          | `lyric_list_bloc.dart`                         |
| BLoC Event | `{feature}_event.dart`                         | `lyric_list_event.dart`                        |
| BLoC State | `{feature}_state.dart`                         | `lyric_list_state.dart`                        |
| Model      | `{name}_model.dart` or `{name}.dart`           | `lyric_model.dart`, `lrc.dart`                 |
| Repository | `{name}_repo.dart` or `{name}_repository.dart` | `local_db_repo.dart`, `lrclib_repository.dart` |
| Service    | `{name}_service.dart`                          | `lrc_process_service.dart`                     |
| Page       | `page.dart` (in feature folder)                | `lyric_list/page.dart`                         |
| Widget     | `{name}.dart` or `{name}_widget.dart`          | `error_dialog_icon_button.dart`                |

## Code Organization Patterns

### Page Architecture (Part Files)

Pages use a three-layer architecture with Dart's `part` directive:

```
feature_name/
├── page.dart           # Public entry point
├── _dependency.dart    # Private: Dependency injection
├── _listener.dart      # Private: Event listeners
└── _view.dart          # Private: UI implementation
```

**Key Points**:

- Main file: `page.dart` (public class)
- Supporting files: Prefixed with `_` (private parts)
- Use `part` directive to include private files
- Use `part of` directive in private files

Example `page.dart`:

```dart
import 'package:flutter/widgets.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class FeatureNamePage extends StatelessWidget {
  const FeatureNamePage({super.key});

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

See [Page Architecture](../../architecture/page-architecture/SKILL.md) for details.

### BLoC Organization

Each BLoC feature has its own folder with separate files:

```
feature_name/
├── feature_name_bloc.dart       # BLoC class
├── feature_name_event.dart      # Events
├── feature_name_state.dart      # States
├── feature_name_bloc.freezed.dart   # Generated
└── (optional) feature_name_bloc.g.dart
```

### Model Organization

Models use freezed for immutability:

```dart
// lyric_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_model.freezed.dart';
part 'lyric_model.g.dart';

@freezed
class LyricModel with _$LyricModel {
  const factory LyricModel({
    required String title,
    required String artist,
    // ... fields
  }) = _LyricModel;

  factory LyricModel.fromJson(Map<String, dynamic> json) =>
      _$LyricModelFromJson(json);
}
```

## Naming Conventions

### Classes

- **PascalCase** for all class names
- Be descriptive and specific

```dart
// ✅ Good
class LyricListBloc
class LocalDbRepo
class ToOverlayMessageService
class OverlayWindowSettingsPage

// ❌ Bad
class lyricListBloc
class localDb
class MessageSvc
class page
```

### Variables & Parameters

- **camelCase** for variables, parameters, and function names
- Use descriptive names

```dart
// ✅ Good
final SharedPreferences pref;
final Box<LrcModel> lrcBox;
String artistName;
void fetchOnlineLyrics();

// ❌ Bad
final SharedPreferences p;
final Box<LrcModel> box;
String an;
void fetch();
```

### Constants

- **lowerCamelCase** for constants (following Dart convention)

```dart
// ✅ Good
const defaultTimeout = Duration(seconds: 30);
const maxRetries = 3;

// ❌ Bad
const DEFAULT_TIMEOUT = Duration(seconds: 30);
const MAX_RETRIES = 3;
```

### Private Members

- Prefix with underscore `_` for private members

```dart
class MyClass {
  // Private field
  final String _privateField;

  // Private method
  void _privateMethod() {}
}
```

## Import Organization

Organize imports in this order:

1. Dart SDK imports
2. Flutter SDK imports
3. External package imports
4. Local relative imports
5. Part directives

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 3. External packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

// 4. Local relative imports
import '../models/lyric_model.dart';
import '../services/lrc/lrc_process_service.dart';

// 5. Part directives
part 'lyric_list_event.dart';
part 'lyric_list_state.dart';
```

**Note**: Use `prefer_relative_imports` for local files (enabled in linter).

## Code Style

### Constructors

- Use `const` constructors when possible
- Use `super.key` for key parameter

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}
```

### Trailing Commas

- Use trailing commas for better formatting and diffs

```dart
// ✅ Good
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Text('Hello'),
  );
}

// ❌ Bad
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Text('Hello')
  );
}
```

### String Literals

- Use single quotes for strings (enforced by `prefer_single_quotes`)

```dart
// ✅ Good
const message = 'Hello World';

// ❌ Bad
const message = "Hello World";
```

## Project Structure

```
lib/
├── apps/                  # App entry points
│   ├── main/             # Main app
│   │   ├── main_app.dart
│   │   └── pages/        # Main app pages
│   └── overlay/          # Overlay app
│       ├── overlay_app.dart
│       └── pages/        # Overlay app pages
│
├── blocs/                # BLoC state management
│   ├── {feature}/        # One folder per feature
│   │   ├── {feature}_bloc.dart
│   │   ├── {feature}_event.dart
│   │   └── {feature}_state.dart
│
├── models/               # Data models (freezed)
│   └── {model}.dart
│
├── repos/                # Data repositories
│   ├── persistence/      # Local data
│   └── lrclib/          # API clients
│
├── services/             # Business logic services
│   ├── db/              # Database services
│   ├── lrc/             # Lyric processing
│   ├── msg_channels/    # Message channels
│   └── platform_channels/ # Platform channels
│
├── routes/               # GoRouter configuration
│   ├── app_router.dart
│   └── {app}_routes.dart
│
├── shells/               # App shells/layouts
│   ├── base/
│   └── overlay/
│
├── widgets/              # Reusable widgets
│   └── {widget}.dart
│
├── l10n/                 # Localization
│   ├── app_en.arb
│   └── app_zh.arb
│
├── hive/                 # Hive type adapters
│   └── hive_registrar.g.dart
│
├── utils/                # Utility functions
│   ├── extensions/
│   └── mixins/
│
├── enums/                # Enumerations
│   └── {enum}.dart
│
├── gen/                  # Generated files
│   └── assets.gen.dart
│
├── firebase_options.dart # Firebase config
└── main.dart             # App entry point
```

## Linting Rules

The project uses strict Flutter linting based on [analysis_options.yaml](../../../analysis_options.yaml).

### Key Enabled Rules

- `strict-casts`: Enforce strict type casts
- `strict-raw-types`: Require type arguments
- `always_declare_return_types`: Always specify return types
- `prefer_const_constructors`: Use const when possible
- `prefer_final_locals`: Use final for local variables
- `prefer_single_quotes`: Use single quotes for strings
- `prefer_relative_imports`: Use relative imports for local files
- `use_key_in_widget_constructors`: Require key in widgets
- `use_super_parameters`: Use super parameters
- `avoid_print`: Don't use print(), use logger instead

### Key Disabled Rules

- `always_specify_types`: Not required (type inference OK)
- `lines_longer_than_80_chars`: No hard line length limit
- `require_trailing_commas`: Not enforced (but recommended)
- `prefer_final_parameters`: Not enforced yet

## Best Practices

### 1. Use Logger Instead of Print

```dart
// ✅ Good
import '../utils/logger.dart';

logger.i('Info message');
logger.e('Error message');

// ❌ Bad
print('Info message');
```

### 2. Use Freezed for Models

```dart
// ✅ Good
@freezed
class MyModel with _$MyModel {
  const factory MyModel({required String name}) = _MyModel;
}

// ❌ Bad
class MyModel {
  final String name;
  MyModel({required this.name});
}
```

### 3. Handle Errors Properly

```dart
// ✅ Good
try {
  await fetchData();
} catch (e, stack) {
  logger.e('Failed to fetch data', error: e, stackTrace: stack);
  rethrow;
}

// ❌ Bad
try {
  await fetchData();
} catch (e) {
  // Empty catch
}
```

### 4. Use BuildContext Safely

```dart
// ✅ Good
void navigateAfterAsync(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  if (!context.mounted) return;
  Navigator.of(context).pop();
}

// ❌ Bad (lint: use_build_context_synchronously)
void navigateAfterAsync(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  Navigator.of(context).pop();
}
```

### 5. Prefer Collection Literals

```dart
// ✅ Good
final list = <String>[];
final map = <String, int>{};

// ❌ Bad
final list = List<String>();
final map = Map<String, int>();
```

## Code Generation

After modifying models, BLoCs, or routes:

```bash
# One-time generation
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

See [Build Commands](../../code-generation/build-commands/SKILL.md) for details.

## Related Skills

- [Page Architecture](../../architecture/page-architecture/SKILL.md) - Page structure pattern
- [FVM Setup](../fvm-setup/SKILL.md) - Flutter version management
- [Freezed Models](../../code-generation/freezed-models/SKILL.md) - Creating immutable models
- [BLoC Structure](../../state-management/bloc-structure/SKILL.md) - BLoC organization
