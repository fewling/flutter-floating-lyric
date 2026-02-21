# Release Notes

## Version 6.0.0+40

### 🎉 Major Release - Codebase Revamp

This is a major release featuring a complete architectural overhaul of the Floating Lyric app. The codebase has been restructured following modern Flutter best practices with improved maintainability and scalability.

### 🏗️ Architecture Improvements

- **Layered Architecture**: Implemented a clean layered architecture pattern for all pages
- **BLoC Pattern**: Migrated to comprehensive BLoC-based state management across the entire app
- **Dependency Injection**: Introduced structured dependency injection with dedicated dependency and listener classes
- **Code Organization**: Better separation of concerns with organized file structure and clear module boundaries

### ✨ New Features

- **Font Selection**: Added ability to customize lyric display fonts with full localization support
- **Lyric Alignment**: New feature to adjust lyric text alignment in the overlay window
- **Scrolling ListView**: Replaced dual-line lyric display with a smooth scrolling ListView
- **Carousel Slider**: Integrated carousel slider for enhanced media state display
- **Tolerance Controls**: Added dedicated controls with input fields for better precision
- **Window Ignore Touch**: New preference to control overlay window touch interactions

### 🎨 UI/UX Enhancements

- **Media State Display**: Improved media state cards with carousel view
- **Window Configuration**: Enhanced window configuration tab with comprehensive settings
- **AutoSizeText Integration**: Better text handling and display in lyric views
- **Layout Improvements**: Replaced Builder with LayoutBuilder for improved layout handling
- **Device Width Handling**: Better responsive design in overlay components

### 🔧 Technical Improvements

- **State Management**: Comprehensive BLoC implementation with:
  - `PermissionBloc` for permission management
  - `PreferenceBloc` for user preferences
  - `MediaListenerBloc` for media state monitoring
  - `OverlayWindowSettingsBloc` for window configurations
  - `LyricFinderBloc` for lyric fetching
  - `LocalLrcPickerBloc` for local LRC file imports
- **Message Passing**: Improved inter-app communication between main and overlay apps
- **Database**: Enhanced local database operations with batch saving functionality
- **Platform Channels**: Better platform-specific integration using MethodChannelService
- **Error Handling**: Enhanced exception handling with dedicated mixins

### 🐛 Bug Fixes

- Fixed file name extraction for LRC files in processing methods
- Corrected lyric line height calculation for better display
- Improved Spotify integration by cleaning artist names for better media state emission
- Enhanced overlay window height and maximum height constraints

### 🌍 Localization

- Added locale support across the application
- Standardized unknown text localization keys
- Improved subtitle formatting with better line breaks
- Updated localization for new features (font selection, alignment, etc.)

### 🔄 Migration Changes

- Migrated from `OverlaySettingsModel` to `OverlayWindowConfig`
- Removed obsolete `WindowChannelService`
- Cleaned up unused components and imports
- Consolidated event and state handling across blocs

### 📦 Dependencies

- Updated package versions in pubspec.lock
- Improved compatibility with latest Flutter SDK

### 🗑️ Removed Features

- Removed animation-related features (streamlined for better performance)
- Cleaned up outdated architecture documentation
- Removed unused database listeners and services

### 📚 Documentation

- Added comprehensive BLoC structure documentation
- Created skill documentation for state management patterns
- Documented dual-app pattern and page architecture
- Included templates for dependencies, listeners, pages, and views

### 🛠️ Development

- Applied `dart fix --apply` for code quality improvements
- Enhanced code structure following best practices
- Improved code readability and maintainability

---

## Previous Versions

### Version 5.1.0+39

- Added user-configurable language selection with SharedPreferences persistence
- Implemented l10n (localization) support

### Version 5.0.2+38

- Refactored main function to handle Firebase initialization with improved error logging

### Version 5.0.1+37

- Fixed file name extraction bug in LRC file processing
- Increased Gradle JVM memory allocation to 4g

### Version 5.0.0+36

- Migrated from Isar database
- Added toggle for "No Lyrics Found" text transparency in overlay settings
- Added "Powered by LrcLib" attribution in online fetch form
- Replaced hardcoded sizes with constants for minimized overlay size
