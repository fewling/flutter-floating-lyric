import 'package:feature_discovery/feature_discovery.dart';
import 'package:floating_lyric/screens/base/base_container.dart';
import 'package:floating_lyric/screens/permission/permission_page.dart';
import 'package:floating_lyric/service/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/permission/permission_notifier.dart';
import 'singletons/song_box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  await SongBox().openBox();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferenceProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPermissionsGranted = ref.watch(permissionProvider.notifier).allPermissionsGranted();

    return FeatureDiscovery(
      child: MaterialApp(
        title: 'Floating Lyric',
        theme: ThemeData(useMaterial3: true),
        home: allPermissionsGranted ? const BaseContainer() : const PermissionPage(),
      ),
    );
  }
}
