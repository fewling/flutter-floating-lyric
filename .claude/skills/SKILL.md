---
name: floating-lyric-app
description: Complete knowledge base for the Floating Lyric Flutter app, covering dual-app architecture, BLoC state management, GoRouter navigation, Hive persistence, and development workflows with FVM.
license: MIT
---

# Floating Lyric App Skills

This is the parent skill indexing all domain knowledge for the Floating Lyric Flutter application - a unique Flutter app with a dual-app architecture featuring a main interface and system overlay for floating lyrics.

## 🏗️ Architecture & Patterns

- **[Architecture Overview](architecture/SKILL.md)** - High-level architecture and design patterns
- **[Page Architecture](architecture/page-architecture/SKILL.md)** - Dependency/Listener/View pattern for pages
- **[Repository Pattern](architecture/repository-pattern/SKILL.md)** - Data flow: Repository → Service → BLoC → UI

## 🔧 Development

- **[Development Workflow](development/SKILL.md)** - Development environment and workflows
- **[FVM Setup](development/fvm-setup/SKILL.md)** - Flutter Version Management setup and usage
- **[Code Conventions](development/code-conventions/SKILL.md)** - Naming, file organization, and code style
- **[Common Commands](development/common-commands/SKILL.md)** - Frequently used development commands

## 🎯 State Management

- **[BLoC Pattern](state-management/SKILL.md)** - State management with flutter_bloc
- **[BLoC Structure](state-management/bloc-structure/SKILL.md)** - Organizing events, states, and blocs
- **[BLoC Communication](state-management/bloc-communication/SKILL.md)** - Inter-BLoC and cross-app messaging

## 🧭 Routing & Navigation

- **[GoRouter Configuration](routing-navigation/SKILL.md)** - Routing setup and navigation
- **[Route Definition](routing-navigation/route-definition/SKILL.md)** - Defining routes with freezed
- **[Route Guards](routing-navigation/route-guards/SKILL.md)** - Permission-based navigation

## 💾 Data & Persistence

- **[Data Persistence](data-persistence/SKILL.md)** - Data layer overview
- **[Hive Storage](data-persistence/hive-storage/SKILL.md)** - Hive setup, type adapters, and boxes
- **[Shared Preferences](data-persistence/shared-preferences/SKILL.md)** - PreferenceRepo pattern

## ⚙️ Code Generation

- **[Code Generation](code-generation/SKILL.md)** - Code generation overview
- **[Freezed Models](code-generation/freezed-models/SKILL.md)** - Creating immutable models with freezed
- **[JSON Serialization](code-generation/json-serialization/SKILL.md)** - JSON serialization patterns
- **[Build Commands](code-generation/build-commands/SKILL.md)** - build_runner commands and workflows

## 🌍 Localization

- **[Localization](localization/SKILL.md)** - Internationalization setup
- **[ARB Files](localization/arb-files/SKILL.md)** - Managing ARB translation files
- **[Locale Switching](localization/locale-switching/SKILL.md)** - Runtime locale switching

## 🎨 Theme & Styling

- **[Theme & Styling](theme-styling/SKILL.md)** - Theming approach and customization
- **[Google Fonts](theme-styling/google-fonts/SKILL.md)** - Using google_fonts package
- **[Color Schemes](theme-styling/color-schemes/SKILL.md)** - Color picker integration

## 📱 Platform Integration

- **[Platform Integration](platform-integration/SKILL.md)** - Platform-specific features
- **[Method Channels](platform-integration/method-channels/SKILL.md)** - Platform channel patterns
- **[Event Channels](platform-integration/event-channels/SKILL.md)** - Event streaming from native
- **[Overlay Window](platform-integration/overlay-window/SKILL.md)** - System overlay implementation

## 🔥 Firebase Integration

- **[Firebase Setup](firebase-integration/SKILL.md)** - Firebase services integration
- **[Crashlytics](firebase-integration/crashlytics/SKILL.md)** - Error tracking setup
- **[Analytics](firebase-integration/analytics/SKILL.md)** - Event tracking patterns

## 🧩 Widgets & Components

- **[Reusable Widgets](widgets/SKILL.md)** - Custom widgets overview
- **[Dialogs](widgets/dialogs/SKILL.md)** - Error dialogs and custom dialogs
- **[Common Components](widgets/common-components/SKILL.md)** - Loading widgets, selectors

## 🧪 Testing

- **[Testing Strategy](testing/SKILL.md)** - Testing approach and patterns
- **[Widget Tests](testing/widget-tests/SKILL.md)** - Widget testing patterns
- **[BLoC Tests](testing/bloc-tests/SKILL.md)** - Testing BLoCs

---

## App Overview

**Floating Lyric** is a Flutter application with a unique dual-app architecture:

- **Main App**: Primary user interface for managing lyrics, settings, and permissions
- **Overlay App**: System overlay window for displaying floating lyrics over other apps

### Tech Stack

- **Flutter SDK**: 3.38.6 (managed via FVM)
- **State Management**: flutter_bloc (BLoC pattern)
- **Routing**: go_router
- **Models**: freezed + json_serializable
- **Persistence**: Hive + SharedPreferences
- **Localization**: flutter_localizations (English, Chinese)
- **Firebase**: Crashlytics, Analytics
- **UI**: google_fonts, lottie, animated_text_kit

### Key Dependencies

```yaml
flutter_bloc: ^9.1.1 # State management
go_router: ^16.2.4 # Routing
freezed: ^3.2.3 # Immutable models
hive_ce: ^2.14.0 # Local storage
firebase_core: ^4.1.1 # Firebase core
google_fonts: ^6.3.2 # Typography
```

### Project Structure

```
lib/
├── apps/              # Main and overlay app entry points
├── blocs/             # BLoC state management
├── models/            # Data models (freezed)
├── repos/             # Data repositories
├── services/          # Business logic services
├── routes/            # GoRouter configuration
├── shells/            # App shells (base layouts)
├── widgets/           # Reusable widgets
├── l10n/              # Localization files
├── hive/              # Hive type adapters
├── utils/             # Utility functions
└── enums/             # Enumerations
```

## Getting Started

1. **Setup FVM**: See [FVM Setup](development/fvm-setup/SKILL.md)
2. **Install Dependencies**: `fvm flutter pub get`
3. **Generate Code**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
4. **Run App**: `fvm flutter run`

For detailed development workflows, see [Development Workflow](development/SKILL.md).
