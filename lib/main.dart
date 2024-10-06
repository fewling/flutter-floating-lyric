import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/routes/app_router.dart';
import 'features/global_dependency_injector/global_dependency_injector.dart';
import 'features/overlay_app/overlay_app.dart';
import 'features/permissions/bloc/permission_bloc.dart';
import 'features/preference/bloc/preference_bloc.dart';
import 'models/lyric_model.dart';
import 'service/permissions/permission_service.dart';
import 'service/platform_methods/permission_channel_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [LrcDBSchema],
    directory: dir.path,
  );
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
  runApp(LayoutBuilder(builder: (context, constraints) {
    return OverlayApp(
      key: rootKey,
    );
  }));
}

class FloatingLyricApp extends StatelessWidget {
  const FloatingLyricApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    final isLight = context.select<PreferenceBloc, bool>((bloc) => bloc.state.isLight);
    final colorSchemeSeed = context.select<PreferenceBloc, int>((bloc) => bloc.state.appColorScheme);
    final fontFamily = context.select<PreferenceBloc, String>((bloc) => bloc.state.fontFamily);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(colorSchemeSeed),
        brightness: isLight ? Brightness.light : Brightness.dark,
        textTheme: fontFamily.isEmpty ? null : GoogleFonts.getTextTheme(fontFamily),
      ),
      routerConfig: appRouter.router,
    );
  }
}
