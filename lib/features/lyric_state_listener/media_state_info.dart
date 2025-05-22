import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../overlay_window_settings/bloc/overlay_window_settings_bloc.dart';
import 'bloc/lyric_state_listener_bloc.dart';

class MediaStateInfo extends StatelessWidget {
  const MediaStateInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<LyricStateListenerBloc, bool>(
      (bloc) => bloc.state.mediaState?.isPlaying ?? false,
    );

    final title = context.select<LyricStateListenerBloc, String>(
      (bloc) => bloc.state.mediaState?.title ?? '',
    );

    final artist = context.select<LyricStateListenerBloc, String>(
      (bloc) => bloc.state.mediaState?.artist ?? '',
    );

    final position = context.select<LyricStateListenerBloc, int>(
      (bloc) => bloc.state.mediaState?.position.toInt() ?? 0,
    );

    final duration = context.select<LyricStateListenerBloc, int>(
      (bloc) => bloc.state.mediaState?.duration.toInt() ?? 0,
    );

    final progress = position / duration;

    final mediaAppName = context.select<LyricStateListenerBloc, String>(
      (bloc) => bloc.state.mediaState?.mediaPlayerName ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.radio_outlined),
          onTap: isPlaying
              ? null
              : () => context.read<LyricStateListenerBloc>().add(
                  const StartMusicPlayerRequested(),
                ),
          trailing: isPlaying
              ? null
              : const Icon(Icons.arrow_forward_ios_outlined),
          title: isPlaying
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$mediaAppName: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '$title - $artist'),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const Text('Play a song'),
          subtitle: isPlaying
              ? LinearProgressIndicator(
                  value: progress.isInfinite || progress.isNaN ? 0 : progress,
                )
              : null,
        ),
        if (!isPlaying)
          ListTile(
            leading: const Icon(Icons.question_mark_outlined),
            title: const Text('Not detecting active music player?'),
            trailing: ElevatedButton.icon(
              onPressed: () => context.read<OverlayWindowSettingsBloc>().add(
                const ToggleNotiListenerSettings(),
              ),
              label: const Text('Re-Enable Manually'),
              icon: const Icon(Icons.refresh_outlined),
            ),
            subtitle: const Text('''
Some heavily customized Android brands (e.g., Huawei, Xiaomi) kill background services aggressively and do not restart them when they should.
'''),
          ),
      ],
    );
  }
}
