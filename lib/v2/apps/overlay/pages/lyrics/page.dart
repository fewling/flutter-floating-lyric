import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../configs/animation_modes.dart';
import '../../../../../configs/main_overlay/search_lyric_status.dart';
import '../../../../../models/overlay_settings_model.dart';
import '../../../../../service/db/local/local_db_service.dart';
import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../blocs/lyric_finder/lyric_finder_bloc.dart';
import '../../../../blocs/msg_from_main/msg_from_main_bloc.dart';
import '../../../../blocs/overlay_app/overlay_app_bloc.dart';
import '../../../../blocs/overlay_window/overlay_window_bloc.dart';
import '../../../../repos/lrclib/lrclib_repository.dart';
import '../../overlay_app.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';
part '_widgets/_overlay_window.dart';

class LyricsPage extends StatelessWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
