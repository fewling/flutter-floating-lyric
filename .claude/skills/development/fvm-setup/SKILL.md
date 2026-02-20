---
name: fvm-setup
description: Flutter Version Management (FVM) setup and usage for the Floating Lyric app. Use this skill when working with FVM commands, switching Flutter versions, or managing the Flutter SDK. Keywords - FVM, Flutter version, SDK management, fvm flutter, version switching.
license: MIT
---

# FVM Setup

This skill covers Flutter Version Management (FVM) configuration and usage in the Floating Lyric project.

## Overview

The Floating Lyric app uses **FVM** to manage Flutter SDK versions, ensuring consistent development environments across the team.

**Current Flutter Version**: `3.38.6`

## Why FVM?

- **Version Consistency**: Everyone on the team uses the same Flutter version
- **Multiple Projects**: Easily switch between different Flutter versions for different projects
- **Stability**: Pin to a specific stable version to avoid breaking changes

## Installation

### Install FVM

```bash
# Using Homebrew (macOS/Linux)
brew tap leoafarias/fvm
brew install fvm

# Using Dart pub
dart pub global activate fvm

# Using Chocolatey (Windows)
choco install fvm
```

### Initialize FVM in Project

The project is already configured with FVM, but if starting fresh:

```bash
# Install the specific Flutter version
fvm install 3.38.6

# Use this version for the project
fvm use 3.38.6
```

This creates:

- `.fvm/` directory with the Flutter SDK
- `.fvm/fvm_config.json` with version configuration

## VS Code Configuration

The project's [.vscode/settings.json](.vscode/settings.json) is configured to use FVM:

```json
{
  "dart.flutterSdkPath": ".fvm/versions/3.38.6"
}
```

This tells VS Code to use the FVM-managed Flutter SDK.

## Common FVM Commands

### Running Flutter Commands

**Always prefix Flutter commands with `fvm`** in this project:

```bash
# Get dependencies
fvm flutter pub get

# Run the app
fvm flutter run

# Build the app
fvm flutter build apk
fvm flutter build ios

# Analyze code
fvm flutter analyze

# Run tests
fvm flutter test

# Code generation
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

### FVM Management Commands

```bash
# List installed Flutter versions
fvm list

# Install a specific version
fvm install 3.38.6

# Use a version for this project
fvm use 3.38.6

# Check which version is being used
fvm flutter --version

# Remove unused Flutter versions
fvm releases
fvm remove <version>

# Upgrade FVM itself
fvm upgrade
```

## IDE Setup

### VS Code

1. Install the **Dart** and **Flutter** extensions
2. The `.vscode/settings.json` is already configured
3. Restart VS Code after FVM setup
4. Verify: Check bottom-right status bar shows "Flutter 3.38.6"

### Android Studio / IntelliJ

1. Go to **Preferences** → **Languages & Frameworks** → **Flutter**
2. Set Flutter SDK path to: `.fvm/versions/3.38.6`
3. Restart IDE

## Troubleshooting

### Command Not Found: fvm

**Solution**: Add FVM to your PATH

```bash
# For Homebrew installation
export PATH="$PATH:$(brew --prefix)/bin"

# For Dart pub installation
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### VS Code Not Using FVM Flutter

**Solution**:

1. Open Command Palette (Cmd+Shift+P / Ctrl+Shift+P)
2. Run: **Dart: Capture Debugging Logs**
3. Check if SDK path points to `.fvm/versions/3.38.6`
4. If not, restart VS Code

### Different Flutter Version Detected

**Solution**:

```bash
# Ensure you're using the project version
fvm use 3.38.6

# Clear Flutter cache
fvm flutter clean
fvm flutter pub get
```

## CI/CD Integration

For continuous integration, FVM can be installed in CI pipelines:

```yaml
# Example GitHub Actions
- name: Install FVM
  run: |
    brew tap leoafarias/fvm
    brew install fvm

- name: Setup Flutter
  run: |
    fvm install 3.38.6
    fvm use 3.38.6

- name: Get Dependencies
  run: fvm flutter pub get
```

## Best Practices

1. **Always use `fvm flutter`** instead of just `flutter` in this project
2. **Commit `.fvm/fvm_config.json`** to version control (already done)
3. **Add `.fvm/` to `.gitignore`** to exclude SDK binaries (already done)
4. **Don't mix FVM and global Flutter** - use one consistently
5. **Update team** when changing Flutter versions

## Updating Flutter Version

When upgrading the Flutter version:

```bash
# 1. Install new version
fvm install 3.40.0

# 2. Switch to new version
fvm use 3.40.0

# 3. Update VS Code settings
# Edit .vscode/settings.json to update version number

# 4. Clean and rebuild
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 5. Test thoroughly before committing
fvm flutter test

# 6. Commit changes
git add .fvm/fvm_config.json .vscode/settings.json
git commit -m "chore: update Flutter to 3.40.0 via FVM"
```

## Quick Reference

| Task                 | Command                                     |
| -------------------- | ------------------------------------------- |
| Install dependencies | `fvm flutter pub get`                       |
| Run app              | `fvm flutter run`                           |
| Build APK            | `fvm flutter build apk`                     |
| Generate code        | `fvm flutter pub run build_runner build -d` |
| Check version        | `fvm flutter --version`                     |
| Clean project        | `fvm flutter clean`                         |
| Analyze code         | `fvm flutter analyze`                       |
| Run tests            | `fvm flutter test`                          |

## Related Skills

- [Common Commands](../common-commands/SKILL.md) - Frequently used development commands
- [Development Workflow](../SKILL.md) - Overall development process
- [Code Generation](../../code-generation/build-commands/SKILL.md) - build_runner with FVM
