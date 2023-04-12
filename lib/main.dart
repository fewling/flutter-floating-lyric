import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/lyric_model.dart';
import 'screens/main/main_screen.dart';
import 'screens/permission/permission_screen.dart';
import 'services/app_preference.dart';
import 'services/db_helper.dart';
import 'services/permission_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await Isar.open([LrcDBSchema]);
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
    final permissionState = ref.watch(permissionStateProvider);
    final allGranted = permissionState.isSystemAlertWindowGranted &&
        permissionState.isNotificationListenerGranted;

    final pref = ref.watch(preferenceProvider);

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(pref.color),
      ),
      home: allGranted ? const MainScreen() : const PermissionScreen(),
    );
  }
}
