import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/lyric_model.dart';
import 'services/db_helper.dart';
import 'services/preferences/app_preference_notifier.dart';
import 'v4/configs/routes/app_router.dart';

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
        sharedPreferenceProvider.overrideWithValue(pref),
      ],
      child: const FloatingLyricApp(),
    ),
  );
}

class FloatingLyricApp extends ConsumerWidget {
  const FloatingLyricApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = ref.watch(
      preferenceNotifierProvider.select((value) => value.isLight),
    );

    final colorSchemeSeed = ref.watch(
      preferenceNotifierProvider.select((value) => value.appColorScheme),
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
