import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/routes/app_router.dart';
import 'features/global_dependency_injector/global_dependency_injector.dart';
import 'features/overlay_app/overlay_app.dart';
import 'features/permissions/bloc/permission_bloc.dart';
import 'features/preference/bloc/preference_bloc.dart';
import 'firebase_options.dart';
import 'models/lyric_model.dart';
import 'service/permissions/permission_service.dart';
import 'service/platform_methods/permission_channel_service.dart';
import 'utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    logger.e('FlutterError: ${errorDetails.exceptionAsString()}');
    if (kDebugMode) return;
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('PlatformDispatcher Error: $error');
    if (kDebugMode) return false;

    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([LrcDBSchema], directory: dir.path);
  final pref = await SharedPreferences.getInstance();

  final permissionBloc = PermissionBloc(
    permissionService: PermissionService(),
    platformMethodService: PermissionChannelService(),
  )..add(const PermissionEventInitial());

  final router = AppRouter(permissionBloc: permissionBloc);

  runApp(
    GlobalDependencyInjector(
      isar: isar,
      pref: pref,
      permissionBloc: permissionBloc,
      child: FloatingLyricApp(appRouter: router),
    ),
  );
}

@pragma('vm:entry-point')
void overlayView() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    LayoutBuilder(
      builder: (context, constraints) {
        return const OverlayApp();
      },
    ),
  );
}

class FloatingLyricApp extends StatelessWidget {
  const FloatingLyricApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final isLight = context.select<PreferenceBloc, bool>(
      (bloc) => bloc.state.isLight,
    );
    final colorSchemeSeed = context.select<PreferenceBloc, int>(
      (bloc) => bloc.state.appColorScheme,
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
    );
  }
}
