part of 'main_app.dart';

class MainAppView extends StatelessWidget {
  const MainAppView({required this.appRouter, super.key});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final isLight = context.select<PreferenceBloc, bool>(
      (bloc) => bloc.state.isLight,
    );
    final colorSchemeSeed = context.select<PreferenceBloc, int>(
      (bloc) => bloc.state.appColorScheme,
    );
    final locale = context.select<PreferenceBloc, AppLocale>(
      (bloc) => bloc.state.locale,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(colorSchemeSeed),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(colorSchemeSeed),
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
