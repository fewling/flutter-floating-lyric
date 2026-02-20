import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/lyric_finder/lyric_finder_bloc.dart';
import '../../../../blocs/msg_from_main/msg_from_main_bloc.dart';
import '../../../../blocs/overlay_app/overlay_app_bloc.dart';
import '../../../../blocs/overlay_window/overlay_window_bloc.dart';
import '../../../../enums/animation_mode.dart';
import '../../../../models/lrc.dart';
import '../../../../models/overlay_window_config.dart';
import '../../../../utils/extensions/custom_extensions.dart';
import '../../../../utils/mixins/overlay_window_sizing_mixin.dart';

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
