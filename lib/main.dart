import 'package:floating_lyric/singletons/window_controller.dart';
import 'package:floating_lyric/ui/homepage.dart';
import 'package:floating_lyric/ui/permission_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'singletons/permission_manager.dart';
import 'singletons/song_box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await SongBox().openBox();
  WindowController().init();
  PermissionManager().init().then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: Obx(
        () => PermissionManager().isSystemAlertWindowGranted
            ? const HomePage()
            : const PermissionPage(),
      ),
    );
  }
}
