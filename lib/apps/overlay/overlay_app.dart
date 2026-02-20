import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/msg_from_main/msg_from_main_bloc.dart';
import '../../blocs/msg_to_main/msg_to_main_bloc.dart';
import '../../blocs/overlay_app/overlay_app_bloc.dart';
import '../../blocs/overlay_window/overlay_window_bloc.dart';
import '../../enums/app_locale.dart';
import '../../l10n/app_localizations.dart';
import '../../routes/app_router.dart';
import '../../services/msg_channels/to_main_msg_service.dart';
import '../../services/platform_channels/layout_channel_service.dart';
import '../../utils/mixins/overlay_window_sizing_mixin.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayAppDependency(
      builder: (context, appRouter) => OverlayAppListener(
        builder: (context) => OverlayAppView(appRouter: appRouter),
      ),
    );
  }
}
