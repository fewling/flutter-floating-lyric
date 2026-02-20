---
name: build-commands
description: build_runner commands and code generation workflow in the Floating Lyric app. Covers build_runner usage, generated files, troubleshooting, and best practices. Use this when running code generation or encountering generation errors.
license: MIT
---

# Build Commands

This skill documents the build_runner workflow and code generation commands used in the Floating Lyric app.

## What is build_runner?

**build_runner** is a Dart package that generates code for:

- **freezed**: Immutable models, union types, copyWith
- **json_serializable**: JSON toJson/fromJson methods
- **hive_generator**: Hive type adapters
- **go_router_builder**: Route generation (if configured)

## When to Run Code Generation

Run build_runner after modifying:

| File Type              | Annotation          | Generated File(s)                     |
| ---------------------- | ------------------- | ------------------------------------- |
| Models with `@freezed` | `@freezed`          | `*.freezed.dart`, `*.g.dart`          |
| BLoC events/states     | `@freezed`          | `*.freezed.dart`                      |
| Models with JSON       | `@JsonSerializable` | `*.g.dart`                            |
| Hive models            | `@HiveType`         | `*.g.dart`                            |
| Routes                 | Part of router      | `app_router.g.dart`, `*.freezed.dart` |
| Hive type adapters     | Auto-registered     | `hive_registrar.g.dart`               |

## Basic Commands

### One-Time Build (Recommended)

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

**Short version**:

```bash
fvm flutter pub run build_runner build -d
```

**When to use**:

- After modifying models, states, events
- After pulling changes from git
- When generated files are missing
- Before committing changes

**What it does**:

- Generates all code
- Deletes conflicting outputs (fixes conflicts)
- Exits when complete

### Watch Mode

```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

**Short version**:

```bash
fvm flutter pub run build_runner watch -d
```

**When to use**:

- During active development
- When making frequent model changes
- When you want automatic regeneration

**What it does**:

- Monitors file changes
- Auto-regenerates on save
- Runs continuously until stopped (Ctrl+C)

**Note**: Watch mode can be resource-intensive. Use for short sessions.

### Clean Build

```bash
# Clean generated files
fvm flutter pub run build_runner clean

# Then rebuild
fvm flutter pub run build_runner build -d
```

**When to use**:

- When experiencing generation errors
- When switching branches with different generated code
- When troubleshooting build issues

## Command Options

### Essential Options

| Option                         | Short | Description                                     |
| ------------------------------ | ----- | ----------------------------------------------- |
| `--delete-conflicting-outputs` | `-d`  | Delete files that conflict with generated files |
| `--verbose`                    | `-v`  | Print detailed output                           |
| `build`                        |       | One-time build                                  |
| `watch`                        |       | Continuous build on file changes                |
| `clean`                        |       | Delete all generated files                      |

### Advanced Options

```bash
# Build with verbose logging
fvm flutter pub run build_runner build -d --verbose

# Build specific directory only
fvm flutter pub run build_runner build -d --build-filter="lib/models/**"

# Set output directory
fvm flutter pub run build_runner build -d --output=build

# Enable/disable deletes
fvm flutter pub run build_runner build --define "build_resolvers|build_to_build_info=enabled=false"
```

## Generated File Types

### 1. Freezed Files (`*.freezed.dart`)

**Generated for**: Models, states, events with `@freezed`

```dart
// Input: lyric_model.dart
@freezed
sealed class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
  }) = _LrcModel;
}

// Generated: lyric_model.freezed.dart
// Contains:
// - _$LrcModel implementation
// - copyWith methods
// - == and hashCode
// - toString
```

### 2. JSON Serialization Files (`*.g.dart`)

**Generated for**: Models with `fromJson`/`toJson`

```dart
// Input: lyric_model.dart
@freezed
sealed class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? title,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}

// Generated: lyric_model.g.dart
// Contains:
// - _$LrcModelFromJson function
// - toJson method implementation
```

### 3. Hive Type Adapters (`hive_registrar.g.dart`)

**Generated for**: All Hive models automatically

```dart
// Auto-generated from all models with TypeAdapter
// Location: lib/hive/hive_registrar.g.dart

extension HiveTypeAdapterRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(LrcModelAdapter());
    // ... other adapters
  }
}
```

**Usage in app**:

```dart
await Hive.initFlutter();
Hive.registerAdapters();  // Registers all adapters
```

### 4. Router Files (`app_router.g.dart`, `*.freezed.dart`)

**Generated for**: Route definitions and path parameters

```dart
// Input: main_route_path_params.dart
@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.localLyricDetail({
    required String id,
  }) = LocalLyricDetailPathParams;

  factory MainRoutePathParams.fromJson(Map<String, dynamic> json) =>
      _$MainRoutePathParamsFromJson(json);
}

// Generated:
// - main_route_path_params.freezed.dart
// - app_router.g.dart (consolidated router)
```

## Development Workflow

### Initial Setup

```bash
# 1. Install dependencies
fvm flutter pub get

# 2. Generate code
fvm flutter pub run build_runner build -d
```

### Daily Development

```bash
# After pulling changes
git pull
fvm flutter pub get
fvm flutter pub run build_runner build -d

# During development (optional)
fvm flutter pub run build_runner watch -d
```

### Before Committing

```bash
# Format code
dart format .

# Regenerate to ensure consistency
fvm flutter pub run build_runner build -d

# Check for errors
fvm flutter analyze
```

### After Switching Branches

```bash
# Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner clean
fvm flutter pub run build_runner build -d
```

## Common Patterns

### Pattern 1: Quick Development Iteration

```bash
# Make changes to model
# Then regenerate
fvm flutter pub run build_runner build -d

# Test changes
fvm flutter run
```

### Pattern 2: Continuous Development

```bash
# Terminal 1: Run watch mode
fvm flutter pub run build_runner watch -d

# Terminal 2: Run app
fvm flutter run

# Make changes, auto-regenerates
```

### Pattern 3: Full Clean Build

```bash
# Complete reset
fvm flutter clean
rm -rf .dart_tool/
fvm flutter pub get
fvm flutter pub run build_runner build -d
```

## Troubleshooting

### Error: "Conflicting outputs"

**Error Message**:

```
[SEVERE] Conflicting outputs were detected and the build is unable to prompt for permission to delete them.
```

**Solution**:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

**Why it happens**:

- Generated files changed format
- Manual edits to generated files
- Version upgrade of generator

### Error: "Duplicate part directive"

**Error Message**:

```
Part directive found but no part file was generated
```

**Solution**:

1. Check `part` directive matches filename exactly:

   ```dart
   part 'lyric_model.freezed.dart';  // Must match exactly
   part 'lyric_model.g.dart';
   ```

2. Ensure file has proper annotations:

   ```dart
   @freezed
   sealed class LrcModel with _$LrcModel { ... }
   ```

3. Regenerate:
   ```bash
   fvm flutter pub run build_runner build -d
   ```

### Error: "Build failed"

**Common causes and solutions**:

1. **Syntax error in source file**

   ```bash
   # Check analyzer output
   fvm flutter analyze

   # Fix errors, then regenerate
   fvm flutter pub run build_runner build -d
   ```

2. **Missing dependency**

   ```yaml
   # Ensure in pubspec.yaml
   dependencies:
     freezed_annotation: ^3.1.0

   dev_dependencies:
     build_runner: ^2.9.0
     freezed: ^3.2.3
     json_serializable: ^6.11.1
   ```

   ```bash
   fvm flutter pub get
   fvm flutter pub run build_runner build -d
   ```

3. **Corrupted build cache**
   ```bash
   fvm flutter pub run build_runner clean
   rm -rf .dart_tool/build/
   fvm flutter pub run build_runner build -d
   ```

### Error: "Generated file not found"

**Solution**:

1. Run build_runner:

   ```bash
   fvm flutter pub run build_runner build -d
   ```

2. If still missing, check:
   - File has necessary annotations (`@freezed`, etc.)
   - `part` directive exists and is correct
   - No syntax errors in file

### Warning: "Build is taking too long"

**Solutions**:

1. **Use build filters** (only build specific directories):

   ```bash
   fvm flutter pub run build_runner build -d \
     --build-filter="lib/models/**"
   ```

2. **Stop watch mode** when not needed:
   - Watch mode runs continuously
   - Use one-time `build` command instead

3. **Clean before building**:
   ```bash
   fvm flutter pub run build_runner clean
   fvm flutter pub run build_runner build -d
   ```

### Error: "Invalid argument"

If build_runner command fails:

1. **Check FVM is used**:

   ```bash
   fvm flutter pub run build_runner build -d
   # NOT: flutter pub run build_runner build -d
   ```

2. **Reinstall dependencies**:
   ```bash
   fvm flutter clean
   fvm flutter pub get
   fvm flutter pub run build_runner build -d
   ```

## Performance Tips

### Faster Builds

1. **Use incremental builds** (default):
   - Don't clean unless necessary
   - build_runner caches previous builds

2. **Build specific directories** when possible:

   ```bash
   fvm flutter pub run build_runner build -d \
     --build-filter="lib/models/**.dart"
   ```

3. **Avoid watch mode** for large projects:
   - Use one-time `build` instead
   - Run only when needed

### CI/CD Optimization

```yaml
# GitHub Actions example
- name: Generate code
  run: |
    fvm flutter pub get
    fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

### DO

✅ **Use `-d` flag** to auto-delete conflicts  
✅ **Run before committing** to ensure generated files are up-to-date  
✅ **Use `build` for production** (one-time, clean output)  
✅ **Use `watch` for development** (auto-regeneration)  
✅ **Clean when switching branches** to avoid conflicts  
✅ **Add `*.g.dart` and `*.freezed.dart` to git** (track generated files)  
✅ **Run after pub get** if dependencies changed

### DON'T

❌ **Don't edit generated files manually** (will be overwritten)  
❌ **Don't commit without regenerating** (inconsistent code)  
❌ **Don't run multiple watch instances** (resource intensive)  
❌ **Don't forget to stop watch mode** (keeps running)  
❌ **Don't ignore build errors** (fix source issues first)  
❌ **Don't use watch in CI/CD** (use one-time build)

## Quick Reference

| Task                      | Command                                     |
| ------------------------- | ------------------------------------------- |
| **Generate code**         | `fvm flutter pub run build_runner build -d` |
| **Auto-regenerate**       | `fvm flutter pub run build_runner watch -d` |
| **Clean generated files** | `fvm flutter pub run build_runner clean`    |
| **Clean & rebuild**       | `clean` then `build -d`                     |
| **Verbose output**        | `build -d --verbose`                        |
| **After git pull**        | `fvm flutter pub get` then `build -d`       |
| **Before commit**         | `build -d` then `analyze`                   |
| **Fix conflicts**         | `build --delete-conflicting-outputs`        |

## Makefile/Scripts (Optional)

Create shortcuts for common tasks:

**Makefile**:

```makefile
.PHONY: gen gen-watch gen-clean

gen:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

gen-watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

gen-clean:
	fvm flutter pub run build_runner clean
	fvm flutter pub run build_runner build --delete-conflicting-outputs
```

**Usage**:

```bash
make gen
make gen-watch
make gen-clean
```

## Related Skills

- [Freezed Models](../freezed-models/SKILL.md) - Creating models that use build_runner
- [BLoC Structure](../../state-management/bloc-structure/SKILL.md) - Events/states with freezed
- [Common Commands](../../development/common-commands/SKILL.md) - Other development commands
- [Development Workflow](../../development/SKILL.md) - When to run generation
