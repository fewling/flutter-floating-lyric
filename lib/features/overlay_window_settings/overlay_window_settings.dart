import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/overlay_window_settings_bloc.dart';

class OverlayWindowSettings extends StatelessWidget {
  const OverlayWindowSettings({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PreferenceBloc, PreferenceState>(
          listener: (context, state) =>
              context.read<OverlayWindowSettingsBloc>().add(PreferenceUpdated(preferenceState: state)),
        ),
        BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
          listener: (context, state) =>
              context.read<OverlayWindowSettingsBloc>().add(LyricStateListenerUpdated(lyricStateListenerState: state)),
        ),
      ],
      child: child,
    );
  }
}
