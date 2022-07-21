import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.initFlutter().then((_) => runApp(const MyApp()));
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
