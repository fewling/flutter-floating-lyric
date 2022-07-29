import 'package:floating_lyric/singletons/window_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'singletons/song_box.dart';
import 'ui/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await SongBox().openBox();
  WindowController().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
