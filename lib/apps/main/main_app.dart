import 'package:awesome_extensions/awesome_extensions_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/app_info/app_info_bloc.dart';
import '../../blocs/lyric_finder/lyric_finder_bloc.dart';
import '../../blocs/media_listener/media_listener_bloc.dart';
import '../../blocs/msg_from_overlay/msg_from_overlay_bloc.dart';
import '../../blocs/msg_to_overlay/msg_to_overlay_bloc.dart';
import '../../blocs/overlay_window_settings/overlay_window_settings_bloc.dart';
import '../../blocs/permission/permission_bloc.dart';
import '../../blocs/preference/preference_bloc.dart';
import '../../blocs/save_lrc/save_lrc_bloc.dart';
import '../../enums/app_locale.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lyric_model.dart';
import '../../models/media_state.dart';
import '../../models/to_main_msg.dart';
import '../../repos/lrclib/lrclib_repository.dart';
import '../../repos/persistence/local/local_db_repo.dart';
import '../../repos/persistence/local/preference_repo.dart';
import '../../routes/app_router.dart';
import '../../services/db/local/local_db_service.dart';
import '../../services/lrc/lrc_process_service.dart';
import '../../services/msg_channels/to_overlay_message_service.dart';
import '../../services/platform_channels/method_channel_service.dart';
import '../../services/platform_channels/permission_channel_service.dart';
import '../../utils/extensions/custom_extensions.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({required this.pref, required this.lrcBox, super.key});

  final SharedPreferences pref;
  final IsolatedBox<LrcModel> lrcBox;

  @override
  Widget build(BuildContext context) {
    return MainAppDependency(
      pref: pref,
      lrcBox: lrcBox,
      builder: (context, appRouter) => MainAppView(appRouter: appRouter),
    );
  }
}
