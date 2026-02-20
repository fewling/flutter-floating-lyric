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

## 🎯 State Management

- **[BLoC Pattern](state-management/SKILL.md)** - State management with flutter_bloc
- **[BLoC Structure](state-management/bloc-structure/SKILL.md)** - Organizing events, states, and blocs

## 🧭 Routing & Navigation

- **[GoRouter Configuration](routing-navigation/SKILL.md)** - Routing setup and navigation
- **[Route Definition](routing-navigation/route-definition/SKILL.md)** - Defining routes with freezed

## 💾 Data & Persistence

- **[Hive Storage](data-persistence/hive-storage/SKILL.md)** - Hive setup, type adapters, and boxes

## ⚙️ Code Generation

- **[Code Generation](code-generation/SKILL.md)** - Code generation overview
- **[Freezed Models](code-generation/freezed-models/SKILL.md)** - Creating immutable models with freezed
- **[Build Commands](code-generation/build-commands/SKILL.md)** - build_runner commands and workflows

## 🌍 Localization

- **[ARB Files](localization/arb-files/SKILL.md)** - Managing ARB translation files

## 📱 Platform Integration

- **[Method Channels](platform-integration/method-channels/SKILL.md)** - Platform channel patterns

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

1. **Install Dependencies**: `fvm flutter pub get`
2. **Generate Code**: `fvm dart run build_runner build -d`
3. **Run App**: `fvm flutter run`

For detailed development workflows, see [Development Workflow](development/SKILL.md).
