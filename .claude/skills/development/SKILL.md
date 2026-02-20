---
name: development-workflow
description: Overall development workflow for the Floating Lyric app, including setup, daily development, testing, and release processes. Use this skill as a starting point for development tasks.
license: MIT
---

# Development Workflow

This skill provides an overview of the development workflow for the Floating Lyric Flutter application.

## Quick Start

For new developers getting started:

```bash
# 1. Clone the repository (if not already done)
# git clone <repository-url>
# cd flutter-floating-lyric

# 2. Install FVM (if not installed)
brew tap leoafarias/fvm
brew install fvm

# 3. Install Flutter version
fvm install 3.38.6
fvm use 3.38.6

# 4. Install dependencies
fvm flutter pub get

# 5. Generate code
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 6. Check setup
fvm flutter doctor

# 7. Run the app
fvm flutter run
```

## Development Environment

### Required Tools

- **FVM**: Flutter Version Management
- **Flutter SDK**: 3.38.6 (via FVM)
- **IDE**: VS Code or Android Studio
- **Android Studio**: For Android development
- **Xcode**: For iOS development (macOS only)

### IDE Setup

#### VS Code

1. Install extensions:
   - Dart
   - Flutter
   - Bloc (optional but recommended)

2. The project is already configured with `.vscode/settings.json`

3. Verify Flutter SDK path points to FVM:

   ```json
   {
     "dart.flutterSdkPath": ".fvm/versions/3.38.6"
   }
   ```

4. Restart VS Code

#### Android Studio

1. Install Flutter plugin
2. Set Flutter SDK path to `.fvm/versions/3.38.6`
3. Restart IDE

## Daily Development Workflow

### 1. Starting Development

```bash
# Pull latest changes
git pull

# Update dependencies (if pubspec.yaml changed)
fvm flutter pub get

# Regenerate code (if models/blocs changed)
fvm flutter pub run build_runner build -d

# Run the app
fvm flutter run
```

### 2. Making Changes

#### Adding a New Feature

1. **Create feature branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Plan the architecture** (following repository pattern)
   - Repository (if new data source needed)
   - Service (business logic)
   - BLoC (state management)
   - Page/Widget (UI)

3. **Implement following conventions**
   - See [Code Conventions](code-conventions/SKILL.md)
   - Use `snake_case` for files
   - Follow [Page Architecture](../architecture/page-architecture/SKILL.md) pattern

4. **Generate code after model/bloc changes**
   ```bash
   fvm flutter pub run build_runner build -d
   ```

#### Modifying Existing Code

1. **Understand the layer**
   - Repository: Data access only
   - Service: Business logic
   - BLoC: State management
   - UI: Rendering

2. **Make changes following existing patterns**

3. **Regenerate if needed**
   ```bash
   fvm flutter pub run build_runner build -d
   ```

### 3. Testing Changes

```bash
# Format code
dart format .

# Analyze code
fvm flutter analyze

# Run tests
fvm flutter test

# Run on device/emulator
fvm flutter run
```

### 4. Committing Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add feature description"
# or
git commit -m "fix: fix description"
# or
git commit -m "refactor: refactor description"

# Push to remote
git push origin feature/your-feature-name
```

## Code Generation Workflow

### When to Generate Code

Generate code after modifying:

- **Models** (with `@freezed` or `@JsonSerializable`)
- **BLoC states/events** (with `@freezed`)
- **Routes** (using `go_router_builder`)
- **Hive adapters** (with `@HiveType`)

### Generation Commands

```bash
# One-time generation (recommended for most cases)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Short version
fvm flutter pub run build_runner build -d

# Watch mode (auto-regenerate on file changes)
fvm flutter pub run build_runner watch -d

# Clean and rebuild
fvm flutter pub run build_runner clean
fvm flutter pub run build_runner build -d
```

### Generated Files

Files ending in:

- `.freezed.dart` - Freezed-generated immutable classes
- `.g.dart` - JSON serialization and Hive adapters
- `hive_registrar.g.dart` - Hive type adapter registration

**Do NOT modify generated files manually!**

## Adding Dependencies

### Adding a Package

```bash
# Add runtime dependency
fvm flutter pub add package_name

# Add dev dependency
fvm flutter pub add --dev package_name

# Example: Add a new package
fvm flutter pub add dio
```

### After Adding

1. Update imports in code
2. Run `fvm flutter pub get`
3. If it affects code generation, run `build_runner`

## Project Structure Understanding

```
lib/
├── apps/              # App entry points (main & overlay)
├── blocs/             # State management (BLoC pattern)
├── models/            # Data models (freezed)
├── repos/             # Repositories (data access)
├── services/          # Services (business logic)
├── routes/            # Router configuration (GoRouter)
├── widgets/           # Reusable widgets
├── l10n/              # Localization files
└── main.dart          # App entry point
```

See [Code Conventions](code-conventions/SKILL.md) for detailed structure.

## Development Modes

### Debug Mode (default)

```bash
fvm flutter run
```

- Hot reload enabled (press `r`)
- Debug console available
- Slower performance
- Larger app size

### Release Mode

```bash
fvm flutter run --release
```

- Optimized performance
- No debug console
- Smaller app size
- Test before release builds

### Profile Mode

```bash
fvm flutter run --profile
```

- Performance profiling enabled
- Some debug features available
- Used for performance testing

## Common Tasks

### Running on Specific Device

```bash
# List available devices
fvm flutter devices

# Run on specific device
fvm flutter run -d <device-id>

# Examples
fvm flutter run -d chrome          # Web (Chrome)
fvm flutter run -d emulator-5554   # Android emulator
fvm flutter run -d macos           # macOS desktop
```

### Hot Reload & Hot Restart

While app is running:

```bash
r  # Hot reload (preserves state)
R  # Hot restart (resets state)
```

### Debugging

```bash
# Run with verbose logging
fvm flutter run -v

# Enable debug paint
# (press 'p' while app is running)

# Open DevTools
# (press 'v' while app is running)
```

### Building Release Versions

```bash
# Android APK
fvm flutter build apk --release

# Android App Bundle (for Play Store)
fvm flutter build appbundle --release

# iOS (requires macOS)
fvm flutter build ios --release
```

## Testing Workflow

### Running Tests

```bash
# Run all tests
fvm flutter test

# Run specific test file
fvm flutter test test/widget_test.dart

# Run with coverage
fvm flutter test --coverage
```

### Before Committing

```bash
# Full pre-commit check
dart format .
fvm flutter analyze
fvm flutter test
```

## Localization Workflow

### Adding Translations

1. **Edit ARB files**:
   - `lib/l10n/app_en.arb` (English)
   - `lib/l10n/app_zh.arb` (Chinese)

2. **Add translation keys**:

   ```json
   {
     "newKey": "English text",
     "@newKey": {
       "description": "Description of the key"
     }
   }
   ```

3. **Generate localization**:

   ```bash
   fvm flutter pub get  # Auto-generates l10n
   ```

4. **Use in code**:

   ```dart
   import '../l10n/app_localizations.dart';

   final l10n = AppLocalizations.of(context)!;
   Text(l10n.newKey)
   ```

See [Localization](../localization/SKILL.md) for details.

## Troubleshooting

### Common Issues

#### 1. Build Errors After Pulling Changes

```bash
# Solution: Clean and regenerate
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build -d
```

#### 2. FVM Not Using Correct Flutter Version

```bash
# Solution: Reinstall FVM Flutter
fvm install 3.38.6
fvm use 3.38.6
# Restart IDE
```

#### 3. Code Generation Conflicts

```bash
# Solution: Delete conflicting outputs
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. VS Code Not Recognizing Imports

```bash
# Solution: Restart Dart Analysis Server
# VS Code Command Palette: "Dart: Restart Analysis Server"
```

#### 5. Hot Reload Not Working

```bash
# Solution: Hot restart
# Press 'R' in terminal or use hot restart in IDE
```

## Best Practices

### DO

✅ Use FVM for all Flutter commands  
✅ Format code before committing (`dart format .`)  
✅ Run analyzer before committing (`fvm flutter analyze`)  
✅ Follow naming conventions (snake_case files, PascalCase classes)  
✅ Use freezed for models  
✅ Follow repository pattern (Repo → Service → BLoC → UI)  
✅ Use logger instead of print  
✅ Add trailing commas for better formatting

### DON'T

❌ Modify generated files manually  
❌ Use `flutter` without `fvm` prefix  
❌ Ignore analyzer warnings  
❌ Commit unformatted code  
❌ Mix business logic in UI  
❌ Access repositories directly from BLoCs  
❌ Use print() for logging

## Release Process

### 1. Pre-Release Checklist

- [ ] All tests pass
- [ ] Code formatted and analyzed
- [ ] Version updated in `pubspec.yaml`
- [ ] Changelog updated
- [ ] Translation files complete
- [ ] Release build tested

### 2. Version Bumping

Edit `pubspec.yaml`:

```yaml
version: 5.2.0+40 # major.minor.patch+buildNumber
```

### 3. Build Release

```bash
# Android
fvm flutter build appbundle --release

# iOS (on macOS)
fvm flutter build ipa --release
```

### 4. Test Release Build

```bash
# Install release build on device
fvm flutter install --release

# Test thoroughly
```

### 5. Commit and Tag

```bash
git add pubspec.yaml
git commit -m "chore: bump version to 5.2.0+40"
git tag v5.2.0
git push origin main --tags
```

## Related Skills

- [FVM Setup](fvm-setup/SKILL.md) - Flutter Version Management
- [Code Conventions](code-conventions/SKILL.md) - Code style and organization
- [Common Commands](common-commands/SKILL.md) - Command reference
- [Repository Pattern](../architecture/repository-pattern/SKILL.md) - Architecture pattern
- [Page Architecture](../architecture/page-architecture/SKILL.md) - Page structure
