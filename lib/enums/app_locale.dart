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
