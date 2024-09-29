import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../../utils/extensions/custom_extensions.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import 'bloc/overlay_window_bloc.dart';

class OverlayWindowListener extends StatelessWidget {
  const OverlayWindowListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OverlayWindowBloc, OverlayWindowState>(
          listener: _onWindowStateUpdated,
        ),
        BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
          listener: _onLyricStateUpdated,
        ),
      ],
      child: child,
    );
  }

  void _onWindowStateUpdated(BuildContext context, OverlayWindowState state) {
    FlutterOverlayWindow.shareData(
      jsonEncode(state.toJson()),
    );
  }

  void _onLyricStateUpdated(BuildContext context, LyricStateListenerState state) {
    final mediaState = state.mediaState;

    final title = mediaState == null ? '' : '${mediaState.title} - ${mediaState.artist}';
    final line1 = state.currentLine;

    final current = mediaState?.position.toInt() ?? 0;
    final max = mediaState?.duration.toInt() ?? 0;
    final position = max == 0 ? 0 : current / max;

    final currentDuration = Duration(milliseconds: current);
    final maxDuration = Duration(milliseconds: mediaState?.duration.toInt() ?? 0);

    context.read<OverlayWindowBloc>().add(LyricStateUpdated(
          title: title,
          line1: line1 ?? 'No line 1',
          line2: line1 ?? 'No line 2',
          position: position.toDouble(),
          positionLeftLabel: currentDuration.mmss(),
          positionRightLabel: maxDuration.mmss(),
        ));
  }
}
