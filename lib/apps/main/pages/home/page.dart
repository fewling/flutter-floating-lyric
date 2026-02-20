import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../blocs/fetch_online_lrc_form/fetch_online_lrc_form_bloc.dart';
import '../../../../blocs/import_local_lrc/import_local_lrc_bloc.dart';
import '../../../../blocs/media_listener/media_listener_bloc.dart';
import '../../../../blocs/msg_to_overlay/msg_to_overlay_bloc.dart';
import '../../../../blocs/overlay_window_settings/overlay_window_settings_bloc.dart';
import '../../../../blocs/preference/preference_bloc.dart';
import '../../../../blocs/start_music_app/start_music_app_bloc.dart';
import '../../../../enums/animation_mode.dart';
import '../../../../models/media_state.dart';
import '../../../../repos/lrclib/lrclib_repository.dart';
import '../../../../routes/app_router.dart';
import '../../../../services/db/local/local_db_service.dart';
import '../../../../services/lrc/lrc_process_service.dart';
import '../../../../services/platform_channels/method_channel_service.dart';
import '../../../../utils/extensions/custom_extensions.dart';
import '../../../../widgets/fail_import_dialog.dart';
import '../../../../widgets/loading_widget.dart';
import '../../main_app.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';
part '_widgets/_local_lyric_tab.dart';
part '_widgets/_media_state_card.dart';
part '_widgets/_media_state_carousel.dart';
part '_widgets/_no_media_tile.dart';
part '_widgets/_online_lyric_tab.dart';
part '_widgets/_window_config_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
