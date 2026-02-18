part of 'overlay_app.dart';

class OverlayAppView extends StatelessWidget {
  const OverlayAppView({required this.appRouter, super.key});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final windowSettings = context.watch<MsgFromMainBloc>().state.settings;

    final appColorScheme = windowSettings?.appColorScheme;
    final isLight = windowSettings?.isLight ?? true;
    final locale = windowSettings?.locale ?? AppLocale.english;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: appColorScheme != null ? Color(appColorScheme) : null,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: appColorScheme != null ? Color(appColorScheme) : null,
        brightness: Brightness.dark,
      ),
      themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
      routerConfig: appRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale.code),
    );
  }
}
