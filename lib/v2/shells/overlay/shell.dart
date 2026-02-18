import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/logger.dart';
import '../../blocs/msg_from_main/msg_from_main_bloc.dart';
import '../../blocs/overlay_app/overlay_app_bloc.dart';
import '../../blocs/overlay_window/overlay_window_bloc.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class OverlayShell extends StatelessWidget {
  const OverlayShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) =>
          _Listener(builder: (context) => _View(child: child)),
    );
  }
}
