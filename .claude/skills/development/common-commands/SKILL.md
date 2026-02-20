---
name: common-commands
description: Frequently used development commands for the Floating Lyric app, including running, building, testing, code generation, and debugging. Use this skill when you need quick reference for development tasks.
license: MIT
---

# Common Commands

This skill provides quick reference for frequently used development commands in the Floating Lyric project.

**Important**: Always prefix Flutter commands with `fvm` in this project. See [FVM Setup](../fvm-setup/SKILL.md).

## Setup & Installation

### Initial Setup

```bash
# Install dependencies
fvm flutter pub get

# Generate code (models, routes, etc.)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Verify installation
fvm flutter doctor
```

### Clean Install

```bash
# Clean project
fvm flutter clean

# Remove generated files
rm -rf .dart_tool/
rm -rf build/

# Reinstall dependencies
fvm flutter pub get

# Regenerate code
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

### Development

```bash
# Run on default device
fvm flutter run

# Run on specific device
fvm flutter devices  # List devices
fvm flutter run -d <device-id>

# Run with hot reload in debug mode
fvm flutter run --debug

# Run in release mode
fvm flutter run --release

# Run in profile mode (for performance profiling)
fvm flutter run --profile
```

### Advanced Run Options

```bash
# Run with specific flavor (if configured)
fvm flutter run --flavor dev

# Run with custom entry point for overlay
# (Overlay app uses different entry point: overlayView)

# Run and specify port for debugging
fvm flutter run --debug-port 5858

# Run with verbose logging
fvm flutter run -v
```

## Building

### Android

```bash
# Build APK (debug)
fvm flutter build apk --debug

# Build APK (release)
fvm flutter build apk --release

# Build App Bundle (for Play Store)
fvm flutter build appbundle --release

# Build APK for specific ABI
fvm flutter build apk --target-platform android-arm64
fvm flutter build apk --split-per-abi  # Separate APKs per ABI
```

### iOS

```bash
# Build iOS app (requires macOS)
fvm flutter build ios --release

# Build IPA for distribution
fvm flutter build ipa --release

# Build without code signing
fvm flutter build ios --no-codesign
```

### Build Outputs

- **Android**: `build/app/outputs/flutter-apk/app-release.apk`
- **iOS**: `build/ios/archive/Runner.xcarchive`

## Code Generation

### build_runner

```bash
# One-time build (recommended for most cases)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files and rebuild
fvm flutter pub run build_runner clean
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Build with debug logging
fvm flutter pub run build_runner build --verbose
```

**Short aliases**:

```bash
# Short version of build command
fvm flutter pub run build_runner build -d

# Short version of watch command
fvm flutter pub run build_runner watch -d
```

### What Gets Generated

- **Freezed models**: `*.freezed.dart` (immutable models)
- **JSON serialization**: `*.g.dart` (toJson/fromJson)
- **Hive adapters**: `*_adapter.g.dart`
- **Router**: `app_router.g.dart`, `app_router.freezed.dart`

### Localization Generation

```bash
# Generate localization files (automatically done with flutter run)
fvm flutter gen-l10n

# Or with pub get
fvm flutter pub get  # Triggers l10n generation
```

**Generated files**: `lib/l10n/app_localizations*.dart`

## Testing

### Run Tests

```bash
# Run all tests
fvm flutter test

# Run specific test file
fvm flutter test test/widget_test.dart

# Run tests with coverage
fvm flutter test --coverage

# Run tests in verbose mode
fvm flutter test --verbose

# Run tests and update golden files
fvm flutter test --update-goldens
```

### Test Coverage

```bash
# Generate coverage report
fvm flutter test --coverage

# View coverage in browser (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Code Analysis & Linting

### Static Analysis

```bash
# Analyze all code
fvm flutter analyze

# Analyze specific file
fvm flutter analyze lib/main.dart

# Fix auto-fixable issues
dart fix --apply
```

### Format Code

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart

# Check formatting without modifying
dart format --output=none --set-exit-if-changed .
```

## Dependency Management

### Add/Update Dependencies

```bash
# Add a new package
fvm flutter pub add package_name

# Add a dev dependency
fvm flutter pub add --dev package_name

# Update dependencies
fvm flutter pub upgrade

# Update a specific package
fvm flutter pub upgrade package_name

# Get dependencies without upgrading
fvm flutter pub get
```

### Remove Dependencies

```bash
# Remove a package
fvm flutter pub remove package_name

# Clean pub cache
fvm flutter pub cache clean
fvm flutter pub cache repair
```

### Check Dependencies

```bash
# List all dependencies
fvm flutter pub deps

# Check for outdated packages
fvm flutter pub outdated

# Show dependency tree
fvm flutter pub deps --style=tree
```

## Debugging

### DevTools

```bash
# Open DevTools
fvm flutter pub global activate devtools
fvm flutter pub global run devtools

# Or use built-in DevTools (when app is running)
# Press 'v' in the terminal to open DevTools in browser
```

### Debugging Options

```bash
# Run with debug logging
fvm flutter run --verbose

# Run with observatory URL printed
fvm flutter run --observatory-port=8888

# Debug with specific device
fvm flutter run -d <device-id> --debug

# Attach to running app
fvm flutter attach
```

### Logs

```bash
# View logs (when app is running)
# Press 's' to capture screenshots
# Press 'w' to dump widget hierarchy
# Press 't' to dump render tree
# Press 'p' to toggle debug paint
# Press 'o' to toggle platform (Android/iOS)

# View Android logs
adb logcat | grep flutter

# Clear and view iOS logs
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "Runner"'
```

## Performance

### Profiling

```bash
# Run in profile mode
fvm flutter run --profile

# Build for performance testing
fvm flutter build apk --profile
```

### Performance Metrics

```bash
# Check app size
fvm flutter build apk --analyze-size

# Measure build performance
fvm flutter build apk --performance-measurement-file=output.json
```

## Clean & Reset

### Clean Build Files

```bash
# Flutter clean
fvm flutter clean

# Remove specific build directories
rm -rf build/
rm -rf .dart_tool/
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies

# Clean iOS build
cd ios && rm -rf Pods/ Podfile.lock && cd ..
```

### Full Reset

```bash
# Complete reset
fvm flutter clean
rm -rf .dart_tool/
rm -rf build/
rm -rf ios/Pods/
rm -rf ios/Podfile.lock
rm -rf android/.gradle/
fvm flutter pub get
fvm flutter pub run build_runner build -d
```

## Firebase

### Firebase Commands

```bash
# Login to Firebase
firebase login

# Initialize Firebase (if needed)
firebase init

# Deploy Firebase configuration
firebase deploy --only hosting
```

## Common Workflows

### After Pulling Changes

```bash
fvm flutter pub get
fvm flutter pub run build_runner build -d
```

### After Modifying Models/BLoCs

```bash
fvm flutter pub run build_runner build -d
```

### Before Committing

```bash
# Format code
dart format .

# Analyze code
fvm flutter analyze

# Run tests
fvm flutter test
```

### Creating a Release Build

```bash
# 1. Update version in pubspec.yaml
# 2. Generate code
fvm flutter pub run build_runner build -d

# 3. Run tests
fvm flutter test

# 4. Build release
fvm flutter build apk --release
# or
fvm flutter build appbundle --release

# 5. Test release build
fvm flutter install --release
```

## Quick Reference Cheat Sheet

| Task                 | Command                                     |
| -------------------- | ------------------------------------------- |
| **Setup**            |                                             |
| Install dependencies | `fvm flutter pub get`                       |
| Generate code        | `fvm flutter pub run build_runner build -d` |
| **Running**          |                                             |
| Run app              | `fvm flutter run`                           |
| Run release mode     | `fvm flutter run --release`                 |
| **Building**         |                                             |
| Build APK            | `fvm flutter build apk --release`           |
| Build App Bundle     | `fvm flutter build appbundle --release`     |
| **Testing**          |                                             |
| Run tests            | `fvm flutter test`                          |
| Test with coverage   | `fvm flutter test --coverage`               |
| **Code Quality**     |                                             |
| Analyze code         | `fvm flutter analyze`                       |
| Format code          | `dart format .`                             |
| Auto-fix issues      | `dart fix --apply`                          |
| **Cleaning**         |                                             |
| Clean build          | `fvm flutter clean`                         |
| Clean & reinstall    | `fvm flutter clean && fvm flutter pub get`  |
| **Dependencies**     |                                             |
| Add package          | `fvm flutter pub add <package>`             |
| Update packages      | `fvm flutter pub upgrade`                   |
| Check outdated       | `fvm flutter pub outdated`                  |

## Keyboard Shortcuts (While Running)

When the app is running with `fvm flutter run`:

| Key | Action                     |
| --- | -------------------------- |
| `r` | Hot reload                 |
| `R` | Hot restart                |
| `h` | Show help                  |
| `c` | Clear screen               |
| `q` | Quit                       |
| `s` | Save screenshot            |
| `w` | Dump widget hierarchy      |
| `t` | Dump render tree           |
| `p` | Toggle debug paint         |
| `P` | Toggle performance overlay |
| `o` | Toggle platform mode       |
| `v` | Open DevTools              |

## Environment Variables

```bash
# Set Flutter SDK path (if not using FVM globally)
export PATH="$PATH:/path/to/.fvm/versions/3.38.6/bin"

# Enable verbose logging
export FLUTTER_VERBOSE=true

# Disable analytics
flutter config --no-analytics
```

## Related Skills

- [FVM Setup](../fvm-setup/SKILL.md) - Flutter Version Management
- [Development Workflow](../SKILL.md) - Overall development process
- [Code Conventions](../code-conventions/SKILL.md) - Code style and organization
- [Build Commands](../../code-generation/build-commands/SKILL.md) - Detailed build_runner usage
