import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/from_overlay_msg_model.dart';
import '../../utils/logger.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../message_channels/message_from_overlay_receiver/bloc/message_from_overlay_receiver_bloc.dart';
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
        BlocListener<MessageFromOverlayReceiverBloc, MessageFromOverlayReceiverState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            logger.d('MessageFromOverlayReceiverBloc: $state');

            final isWindowTouched = state.msg?.action?.isWindowTouched ?? false;
            logger.d('isWindowTouched: $isWindowTouched');

            if (isWindowTouched) {
              context.read<OverlayWindowSettingsBloc>().add(const LyricOnlyModeToggled());
            }
          },
        ),
      ],
      child: child,
    );
  }
}
