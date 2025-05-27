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
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.touch_app_outlined),
                  title: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Not detecting active music player?',
                      maxLines: 1,
                    ),
                  ),
                  subtitle: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tap here to re-enable the notification listener',
                      maxLines: 1,
                    ),
                  ),
                  trailing: TextButton(
                    child: Text(
                      'Learn More',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        icon: Icon(Icons.info_outline),
                        title: Text('Notification Listener'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(
                              'On some Android devices (such as those from Huawei or Xiaomi), system-level battery and memory management features may restrict background services, including the notification listener required for music detection.',
                            ),
                            Text(
                              'If the app is closed, these optimizations can terminate the background service after a short period, and it may not restart automatically.',
                            ),
                            Text(
                              'If music is not being detected, please tap the button above to manually re-enable the notification listener.',
                            ),
                            Text(
                              'Due to manufacturer-specific customizations and limited documentation, ensuring reliable background operation on these devices can be challenging. We appreciate your understanding as we continue to improve compatibility.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () => context.read<OverlayWindowSettingsBloc>().add(
                    const ToggleNotiListenerSettings(),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
