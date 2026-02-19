import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'hive/hive_registrar.g.dart';
import 'models/lyric_model.dart';
import 'utils/logger.dart';
import 'v2/apps/main/main_app.dart';
import 'v2/apps/overlay/overlay_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (errorDetails) {
      logger.e('FlutterError: ${errorDetails.exceptionAsString()}');
      if (kDebugMode) return;
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      logger.e('PlatformDispatcher Error: $error');
      if (kDebugMode) return false;

      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } finally {
    final (pref, lrcModelBox) = await bootstrap();

    runApp(MainApp(pref: pref, lrcBox: lrcModelBox));
  }
}

@pragma('vm:entry-point')
Future<void> overlayView() async {
  WidgetsFlutterBinding.ensureInitialized();

  final (pref, lrcModelBox) = await bootstrap();

  runApp(
    LayoutBuilder(
      builder: (context, constraints) => OverlayApp(lrcBox: lrcModelBox),
    ),
  );
}

Future<(SharedPreferences, Box<LrcModel>)> bootstrap() async {
  final pref = await SharedPreferences.getInstance();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  Hive.registerAdapters();
  final lrcModelBox = await Hive.openBox<LrcModel>('lrc', path: dir.path);

  return (pref, lrcModelBox);
}
