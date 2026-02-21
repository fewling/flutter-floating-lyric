---
name: arb-files
description: Detailed guide to internationalization (i18n) using ARB files in Floating Lyric app, covering ARB file structure, adding translations, code generation, locale switching, and best practices.
license: MIT
---

# ARB Files (Internationalization)

This skill provides comprehensive documentation on internationalization (i18n) using ARB (Application Resource Bundle) files in the Floating Lyric app.

## Overview

The Floating Lyric app supports **multiple languages** using Flutter's built-in localization system.

**Current Languages**:

- 🇺🇸 **English** (`en`)
- 🇨🇳 **Chinese (Traditional)** (`zh`)

**Framework**: `flutter_localizations` + ARB files

## Setup

### Dependencies

**File**: [pubspec.yaml](../../../pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  intl: ^0.20.2 # Required for ARB generation
```

### Localization Configuration

**File**: [l10n.yaml](../../../l10n.yaml)

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**Configuration**:

- `arb-dir` — Directory containing ARB files
- `template-arb-file` — Primary ARB file (English)
- `output-localization-file` — Generated Dart file name

### Generated Files

**Location**: `lib/l10n/`

**Files**:

- `app_localizations.dart` — Base localization class
- `app_localizations_en.dart` — English translations
- `app_localizations_zh.dart` — Chinese translations

**Note**: Generated files are NOT committed (in `.gitignore`).

## ARB File Structure

### English (Template)

**File**: [lib/l10n/app_en.arb](../../../lib/l10n/app_en.arb)

```json
{
  "@@locale": "en",
  "permission_screen_notif_listener_permission_title": "Notification Listener Permission",
  "permission_screen_notif_listener_permission_instruction": "This app needs to access the music player in the notification bar to work.",
  "language": "Language",
  "language_english": "English",
  "language_chinese": "中文",
  "home": "Home",
  "storedLyrics": "Stored Lyrics",
  "settings": "Settings",
  ...
}
```

**Structure**:

- `@@locale` — Locale identifier (required)
- `key`: `value` — Translation pairs

### Chinese (Translation)

**File**: [lib/l10n/app_zh.arb](../../../lib/l10n/app_zh.arb)

```json
{
  "@@locale": "zh",
  "permission_screen_notif_listener_permission_title": "通知監聽權限",
  "permission_screen_notif_listener_permission_instruction": "此應用需要存取通知列中的音樂播放器才能正常運作。",
  "language": "語言",
  "language_english": "English",
  "language_chinese": "中文",
  "home": "首頁",
  "storedLyrics": "本地歌詞",
  "settings": "設定",
  ...
}
```

**Key Requirements**:

- Keys must **match exactly** across all ARB files
- `@@locale` must match the file suffix (`app_en.arb` → `"en"`, `app_zh.arb` → `"zh"`)

## Naming Conventions

### Screen-Based Naming

**Pattern**: `<screen>_<widget>_<purpose>`

**Examples**:

```json
{
  "permission_screen_grant_access": "Grant Access",
  "permission_screen_done": "Done",
  "permission_screen_missing_permission": "Missing Permission",

  "home_screen_window_configs": "Window Configs",
  "home_screen_import_lyrics": "Import Lyrics",
  "home_screen_online_lyrics": "Online Lyrics",

  "lyric_list_import": "Import",
  "lyric_list_delete": "Delete",
  "lyric_list_delete_all": "Delete All",
  "lyric_list_no_lyrics_found": "No lyrics found."
}
```

**Why**: Easy to locate translations, prevents key collisions.

### Shared/Common Strings

**Pattern**: `<context>_<purpose>`

**Examples**:

```json
{
  "language": "Language",
  "language_english": "English",
  "language_chinese": "中文",

  "error_dialog_title": "Something went wrong",
  "error_dialog_ok": "OK",
  "error_dialog_report": "Report"
}
```

### Dialog Messages

**Pattern**: `<feature>_<dialog_type>_<field>`

**Examples**:

```json
{
  "lyric_list_delete_all_title": "Delete All Lyric",
  "lyric_list_delete_all_message": "Are you sure you want to delete All lyrics?",

  "lyric_list_delete_title": "Delete Lyric",
  "lyric_list_delete_message": "Are you sure you want to delete this lyric?"
}
```

### Multi-Part Messages

For messages split across multiple keys (e.g., instructions):

```json
{
  "permission_screen_notif_listener_permission_step1": "1. Grant Access button",
  "permission_screen_notif_listener_permission_step2": "2. This app",
  "permission_screen_notif_listener_permission_step3": "3. Turn on \"Allow notification access\""
}
```

## Code Generation

### Generate Localization Files

```bash
fvm flutter gen-l10n
```

**Or** (via build_runner, which also runs gen-l10n):

```bash
fvm dart run build_runner build -d
```

**Generated Files**:

- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_zh.dart`

**Watch Mode**:

```bash
fvm flutter gen-l10n --watch
```

**Note**: Run after adding/modifying ARB files.

### Generated API

**File**: `lib/l10n/app_localizations.dart` (generated)

```dart
abstract class AppLocalizations {
  String get permission_screen_grant_access;
  String get home;
  String get settings;
  // ... all keys as getters

  static AppLocalizations? of(BuildContext context);
  static const LocalizationsDelegate<AppLocalizations> delegate;
  static const List<Locale> supportedLocales;
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates;
}
```

## Usage in Code

### Setup in App

**File**: [lib/apps/main/\_view.dart](../../../lib/apps/main/_view.dart)

```dart
class MainAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = context.select<PreferenceBloc, AppLocale>(
      (bloc) => bloc.state.locale,
    );

    return MaterialApp.router(
      // Localization configuration
      locale: Locale(locale.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Router
      routerConfig: appRouter,

      // Theme
      theme: themeData,
    );
  }
}
```

**Key Points**:

- `locale` — Current locale from `PreferenceBloc`
- `localizationsDelegates` — Includes `AppLocalizations.delegate`
- `supportedLocales` — Auto-generated from ARB files

### Accessing Translations

#### Using BuildContext Extension

**File**: [lib/utils/extensions/build_context_x.dart](../../../lib/utils/extensions/build_context_x.dart)

```dart
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

**Usage**:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.home); // "Home" or "首頁"
  }
}
```

#### Direct Access

```dart
final localizations = AppLocalizations.of(context)!;
Text(localizations.settings); // "Settings" or "設定"
```

**Best Practice**: Use the `context.l10n` extension for brevity.

## Locale Management

### AppLocale Enum

**File**: [lib/enums/app_locale.dart](../../../lib/enums/app_locale.dart)

```dart
enum AppLocale { english, zhHK }

extension AppLocaleX on AppLocale {
  String get code {
    switch (this) {
      case AppLocale.english:
        return 'en';
      case AppLocale.zhHK:
        return 'zh';
    }
  }

  String get displayName {
    switch (this) {
      case AppLocale.english:
        return 'English';
      case AppLocale.zhHK:
        return '繁體中文';
    }
  }
}

AppLocale appLocaleFromJson(String str) => AppLocale.values.firstWhere(
  (locale) => locale.code == str,
  orElse: () => AppLocale.english,
);

String appLocaleToJson(AppLocale locale) => locale.code;
```

**Usage**:

- `AppLocale.english.code` → `"en"`
- `AppLocale.zhHK.code` → `"zh"`
- `AppLocale.english.displayName` → `"English"`
- `AppLocale.zhHK.displayName` → `"繁體中文"`

### Locale Switching

**Flow**:

1. User selects language in settings
2. UI dispatches `PreferenceEvent.localeUpdated(AppLocale)`
3. `PreferenceBloc` saves to `PreferenceRepo`
4. State emits with new locale
5. `MaterialApp` rebuilds with new `Locale`

**Example**:

```dart
// Language selector widget
class LanguageSelector extends StatelessWidget {
  final AppLocale value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppLocale>(
      value: value,
      items: [
        for (final locale in AppLocale.values)
          DropdownMenuItem(
            value: locale,
            child: Text(locale.displayName),
          ),
      ],
      onChanged: (newLocale) {
        if (newLocale != null) {
          context.read<PreferenceBloc>().add(
            PreferenceEvent.localeUpdated(newLocale),
          );
        }
      },
    );
  }
}
```

### Persistence

**File**: [lib/repos/persistence/local/preference_repo.dart](../../../lib/repos/persistence/local/preference_repo.dart)

```dart
class PreferenceRepo {
  final SharedPreferences _pref;

  AppLocale get locale {
    final code = _pref.getString('locale') ?? 'en';
    return appLocaleFromJson(code);
  }

  Future<void> setLocale(AppLocale locale) async {
    await _pref.setString('locale', appLocaleToJson(locale));
  }
}
```

**Storage**: `SharedPreferences` (persists across app restarts)

## Adding New Translations

### Step 1: Add to Template (English)

**File**: [lib/l10n/app_en.arb](../../../lib/l10n/app_en.arb)

```json
{
  "@@locale": "en",
  "new_feature_title": "New Feature Title",
  "new_feature_subtitle": "This is a new feature description."
}
```

### Step 2: Add to All Translations

**File**: [lib/l10n/app_zh.arb](../../../lib/l10n/app_zh.arb)

```json
{
  "@@locale": "zh",
  "new_feature_title": "新功能標題",
  "new_feature_subtitle": "這是新功能的描述。"
}
```

**Important**: Keys must match across all ARB files.

### Step 3: Generate Localization Files

```bash
fvm flutter gen-l10n
```

### Step 4: Use in Code

```dart
Text(context.l10n.new_feature_title);
```

## Advanced ARB Features

### Placeholders

For dynamic values:

**ARB File**:

```json
{
  "welcome_message": "Welcome, {username}!",
  "@welcome_message": {
    "description": "Welcome message with username",
    "placeholders": {
      "username": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

**Usage**:

```dart
Text(context.l10n.welcome_message('Alice')); // "Welcome, Alice!"
```

**Note**: Current app doesn't extensively use placeholders; could be added.

### Metadata (Descriptions)

For translator context:

```json
{
  "overlay_window_hide": "Hide",
  "@overlay_window_hide": {
    "description": "Button to hide the overlay window"
  }
}
```

**Why**: Helps translators understand context.

### Plurals

For quantity-based translations:

```json
{
  "lyric_count": "{count, plural, =0{No lyrics} =1{1 lyric} other{{count} lyrics}}",
  "@lyric_count": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage**:

```dart
Text(context.l10n.lyric_count(5)); // "5 lyrics"
```

**Note**: Not heavily used in current app.

## Overlay App Localization

The overlay app reads locale from window configuration (sent from main app).

**File**: [lib/apps/overlay/\_view.dart](../../../lib/apps/overlay/_view.dart)

```dart
class OverlayAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windowConfig = context.watch<OverlayWindowBloc>().state.config;
    final locale = windowConfig?.locale ?? AppLocale.english;

    return MaterialApp.router(
      locale: Locale(locale.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
```

**Flow**:

1. Main app user changes language
2. Main app sends `ToOverlayMsgConfig` with new locale
3. Overlay app receives message
4. `OverlayWindowBloc` updates config
5. Overlay app rebuilds with new locale

## Common UI Strings

### Permission Screen

```json
{
  "permission_screen_notif_listener_permission_title": "Notification Listener Permission",
  "permission_screen_overlay_window_permission_title": "Overlay Window Permission",
  "permission_screen_grant_access": "Grant Access",
  "permission_screen_done": "Done",
  "permission_screen_missing_permission": "Missing Permission"
}
```

### Home/Navigation

```json
{
  "home": "Home",
  "storedLyrics": "Stored Lyrics",
  "settings": "Settings",
  "language": "Language"
}
```

### Lyric List

```json
{
  "lyric_list_import": "Import",
  "lyric_list_delete": "Delete",
  "lyric_list_delete_all": "Delete All",
  "lyric_list_cancel": "Cancel",
  "lyric_list_refresh": "Refresh",
  "lyric_list_search": "Search",
  "lyric_list_no_lyrics_found": "No lyrics found."
}
```

### Overlay Window

```json
{
  "overlay_window_hide": "Hide",
  "overlay_window_show": "Show",
  "overlay_window_styling": "Styling",
  "overlay_window_no_lyric": "No lyric",
  "overlay_window_searching_lyric": "Searching lyric...",
  "overlay_window_waiting_for_music_player": "Waiting for music player"
}
```

### Error Dialogs

```json
{
  "error_dialog_title": "Something went wrong",
  "error_dialog_ok": "OK",
  "error_dialog_report": "Report",

  "lyric_detail_error_saving_lyric": "Error saving lyric",
  "lyric_list_error_deleting_lyric": "Error deleting lyric."
}
```

## Best Practices

### 1. Consistent Naming

Use screen-based prefixes for organization:

```json
// ✅ Good
{
  "home_screen_window_configs": "Window Configs",
  "home_screen_import_lyrics": "Import Lyrics",
  "home_screen_online_lyrics": "Online Lyrics"
}

// ❌ Bad (no context)
{
  "window_configs": "Window Configs",
  "import": "Import Lyrics",
  "online": "Online Lyrics"
}
```

### 2. Avoid Hardcoded Strings

Always use localization for user-facing text:

```dart
// ✅ Good
Text(context.l10n.settings);

// ❌ Bad
Text('Settings');
```

### 3. Key Consistency Across ARB Files

Ensure all ARB files have the same keys:

**English**:

```json
{
  "home": "Home",
  "settings": "Settings"
}
```

**Chinese** (must have same keys):

```json
{
  "home": "首頁",
  "settings": "設定"
}
```

**Validation**: Run `fvm flutter gen-l10n` — it will fail if keys mismatch.

### 4. Sort Keys Alphabetically (Optional)

For easier maintenance:

```json
{
  "error_dialog_ok": "OK",
  "error_dialog_report": "Report",
  "error_dialog_title": "Something went wrong",
  "home": "Home",
  "settings": "Settings"
}
```

**Note**: Current app groups by screen/feature, which is also valid.

### 5. Use Descriptions for Complex Strings

```json
{
  "overlay_window_touch_through_subtitle": "This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\\nSuch issue is due to Android's design limitation and is out of this app's control. 🙏",
  "@overlay_window_touch_through_subtitle": {
    "description": "Warning message explaining touch-through behavior and limitations"
  }
}
```

**Why**: Helps translators understand context and intent.

### 6. Escape Special Characters

Use `\\n` for newlines, `\\'` for quotes:

```json
{
  "message": "Line 1\\nLine 2",
  "quote": "He said, \\'Hello\\'"
}
```

### 7. Test All Locales

Switch between languages in app to verify:

- No missing keys
- No layout overflow (Chinese text may be shorter/longer)
- Proper formatting

## Common Pitfalls

### 1. Missing Keys

**Problem**: Key exists in `app_en.arb` but not in `app_zh.arb`

**Solution**: Always add keys to all ARB files

**Error**: `gen-l10n` will fail with missing key error

### 2. Key Mismatch

**Problem**: Typo in key name across files

```json
// app_en.arb
{ "home_screen_title": "Home" }

// app_zh.arb
{ "home_scren_title": "首頁" } // Typo: "scren"
```

**Solution**: Double-check key names, use IDE autocomplete

### 3. Locale Not Switching

**Problem**: Changing locale doesn't update UI

**Solution**: Ensure `MaterialApp` uses `locale` from state:

```dart
MaterialApp.router(
  locale: Locale(locale.code), // Must be reactive
  ...
)
```

### 4. Forgetting to Generate

**Problem**: Added new keys but they're not available in code

**Solution**: Run `fvm flutter gen-l10n` after ARB changes

### 5. Hardcoded Fallback

**Problem**: Using hardcoded fallback instead of localization

```dart
// ❌ Bad
Text(title ?? 'Home'); // Hardcoded fallback

// ✅ Good
Text(title ?? context.l10n.home);
```

## Adding a New Language

### Step 1: Create ARB File

**File**: `lib/l10n/app_es.arb` (Spanish example)

```json
{
  "@@locale": "es",
  "home": "Inicio",
  "settings": "Configuración",
  ...
}
```

**Name**: `app_<locale>.arb` (e.g., `app_es.arb`, `app_fr.arb`)

### Step 2: Add to AppLocale Enum

**File**: [lib/enums/app_locale.dart](../../../lib/enums/app_locale.dart)

```dart
enum AppLocale { english, zhHK, spanish } // Add new value

extension AppLocaleX on AppLocale {
  String get code {
    switch (this) {
      case AppLocale.english:
        return 'en';
      case AppLocale.zhHK:
        return 'zh';
      case AppLocale.spanish:
        return 'es'; // Add case
    }
  }

  String get displayName {
    switch (this) {
      case AppLocale.english:
        return 'English';
      case AppLocale.zhHK:
        return '繁體中文';
      case AppLocale.spanish:
        return 'Español'; // Add case
    }
  }
}
```

### Step 3: Generate Localizations

```bash
fvm flutter gen-l10n
```

**Generated**: `app_localizations_es.dart`

### Step 4: Update JSON Serialization

**File**: [lib/enums/app_locale.dart](../../../lib/enums/app_locale.dart)

```dart
AppLocale appLocaleFromJson(String str) => AppLocale.values.firstWhere(
  (locale) => locale.code == str,
  orElse: () => AppLocale.english,
);

String appLocaleToJson(AppLocale locale) => locale.code;
```

**Note**: These functions should work automatically with the enum extension.

### Step 5: Test

1. Switch to new language in settings
2. Verify all screens display correct translations
3. Test in both Main and Overlay apps

## Debugging

### Check Supported Locales

```dart
print(AppLocalizations.supportedLocales);
// Output: [Locale('en'), Locale('zh')]
```

### Inspect Current Locale

```dart
final locale = Localizations.localeOf(context);
print('Current locale: ${locale.languageCode}');
```

### Force Locale (Testing)

```dart
MaterialApp.router(
  locale: const Locale('zh'), // Force Chinese
  ...
)
```

## Related Skills

- [State Management - PreferenceBloc](../../state-management/SKILL.md) — Locale state
- [Code Generation - Build Commands](../../code-generation/build-commands/SKILL.md) — Running gen-l10n
- [Dual-App Pattern](../../architecture/dual-app-pattern/SKILL.md) — Locale sync between apps
- [Development - Code Conventions](../../development/code-conventions/SKILL.md) — Naming patterns

## Summary

Localization in Floating Lyric:

- ✅ **ARB files** — JSON-based translations
- ✅ **Code generation** — `flutter gen-l10n` creates type-safe API
- ✅ **AppLocale enum** — Type-safe locale management
- ✅ **SharedPreferences** — Persist user's language preference
- ✅ **Dual-app support** — Locale synced via message passing
- ✅ **BuildContext extension** — Convenient `context.l10n` access

**Key Files**:

- [lib/l10n/app_en.arb](../../../lib/l10n/app_en.arb) — English translations
- [lib/l10n/app_zh.arb](../../../lib/l10n/app_zh.arb) — Chinese translations
- [lib/enums/app_locale.dart](../../../lib/enums/app_locale.dart) — Locale enum
- [l10n.yaml](../../../l10n.yaml) — Localization config
- [lib/utils/extensions/build_context_x.dart](../../../lib/utils/extensions/build_context_x.dart) — Context extension
