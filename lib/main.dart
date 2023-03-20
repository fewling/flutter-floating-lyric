import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/base/base_container.dart';
import 'screens/permission/permission_notifier.dart';
import 'screens/permission/permission_page.dart';
import 'service/app_preferences.dart';
import 'service/song_box.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FeatureDiscovery(
      child: MaterialApp(
        title: 'Floating Lyric',
        theme: ThemeData(useMaterial3: true),
        home: ref.watch(permissionProvider).when(
              data: (data) => data.notificationListenerGranted && data.systemAlertWindowGranted
                  ? const BaseContainer()
                  : const PermissionPage(),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}
