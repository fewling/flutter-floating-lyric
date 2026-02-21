part of 'overlay_app.dart';

class OverlayAppView extends StatelessWidget {
  const OverlayAppView({required this.appRouter, super.key});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final windowConfig = context.watch<MsgFromMainBloc>().state.config;

    final appColorScheme = windowConfig?.appColorScheme;
    final isLight = windowConfig?.isLight ?? true;
    final locale = windowConfig?.locale ?? AppLocale.english;
    final fontFamily = windowConfig?.fontFamily;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: appColorScheme != null ? Color(appColorScheme) : null,
        brightness: Brightness.light,
        textTheme: fontFamily == null || fontFamily.isEmpty
            ? null
            : GoogleFonts.getTextTheme(fontFamily),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: appColorScheme != null ? Color(appColorScheme) : null,
        brightness: Brightness.dark,
        textTheme: fontFamily == null || fontFamily.isEmpty
            ? null
            : GoogleFonts.getTextTheme(fontFamily),
      ),
      themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
      routerConfig: appRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(locale.code),
    );
  }
}
