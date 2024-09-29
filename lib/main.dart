import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/lyric_model.dart';
import 'services/db_helper.dart';
import 'services/lrclib/repo/lrclib_repository.dart';
import 'v4/configs/routes/app_router.dart';
import 'v4/features/overlay_window/overlay_window.dart';
import 'v4/features/preference/bloc/preference_bloc.dart';
import 'v4/repos/local/preference_repo.dart';
import 'v4/service/preference/preference_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [LrcDBSchema],
    directory: dir.path,
  );
  final pref = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        dbHelperProvider.overrideWithValue(DBHelper(isar)),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => DBHelper(isar),
          ),
          RepositoryProvider(
            create: (context) => LrcLibRepository(),
          ),
          RepositoryProvider(
            create: (context) => PreferenceRepo(sharedPreferences: pref),
          ),
        ],
        child: BlocProvider(
          create: (context) => PreferenceBloc(
            spService: PreferenceService(
              spRepo: context.read<PreferenceRepo>(),
            ),
          )..add(const PreferenceEventLoad()),
          child: const FloatingLyricApp(),
        ),
      ),
    ),
  );
}

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OverlayWindow(),
      ),
    ),
  );
}

class FloatingLyricApp extends ConsumerWidget {
  const FloatingLyricApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
