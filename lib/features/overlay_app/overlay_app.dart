import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../overlay_window/overlay_window.dart';
import 'bloc/overlay_app_bloc.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OverlayAppBloc()..add(const OverlayAppStarted()),
        ),
      ],
      child: const MaterialApp(
        home: OverlayWindow(),
      ),
    );
  }
}
