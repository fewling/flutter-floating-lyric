import 'package:floating_lyric/features/global_dependency_injector/global_dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/routes/app_router.dart';
import 'features/overlay_window/overlay_window.dart';
import 'features/permissions/bloc/permission_bloc.dart';
import 'features/preference/bloc/preference_bloc.dart';
import 'models/lyric_model.dart';
import 'service/permissions/permission_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [LrcDBSchema],
    directory: dir.path,
  );
  final pref = await SharedPreferences.getInstance();

  runApp(
    GlobalDependencyInjector(
      isar: isar,
      pref: pref,
      child: const FloatingLyricApp(),
    ),
  );
}

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayWindow(),
    ),
  );
}

class FloatingLyricApp extends StatefulWidget {
  const FloatingLyricApp({super.key});

  @override
  State<FloatingLyricApp> createState() => _FloatingLyricAppState();
}

class _FloatingLyricAppState extends State<FloatingLyricApp> {
  late final PermissionBloc _permissionBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _permissionBloc = PermissionBloc(
      permissionService: PermissionService(),
    )..add(const PermissionEventInitial());

    _appRouter = AppRouter(
      permissionBloc: _permissionBloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _permissionBloc),
      ],
      child: Builder(builder: (context) {
        final isLight = context.select<PreferenceBloc, bool>(
          (bloc) => bloc.state.isLight,
        );

        final colorSchemeSeed = context.select<PreferenceBloc, int>(
          (bloc) => bloc.state.appColorScheme,
        );

        return MaterialApp.router(
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Color(colorSchemeSeed),
            brightness: isLight ? Brightness.light : Brightness.dark,
          ),
          routerConfig: _appRouter.router,
        );
      }),
    );
  }
}
