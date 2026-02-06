import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../overlay_window_settings/bloc/overlay_window_settings_bloc.dart';
import 'bloc/lyric_state_listener_bloc.dart';

class MediaStateInfo extends StatelessWidget {
  const MediaStateInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              : Text(l10n.media_state_play_song),
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
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.media_state_not_detecting_title,
                      maxLines: 1,
                    ),
                  ),
                  subtitle: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.media_state_not_detecting_subtitle,
                      maxLines: 1,
                    ),
                  ),
                  trailing: TextButton(
                    child: Text(
                      l10n.media_state_learn_more,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.info_outline),
                        title: Text(
                          l10n.media_state_notification_listener_title,
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(l10n.media_state_notification_listener_info1),
                            Text(l10n.media_state_notification_listener_info2),
                            Text(l10n.media_state_notification_listener_info3),
                            Text(l10n.media_state_notification_listener_info4),
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
