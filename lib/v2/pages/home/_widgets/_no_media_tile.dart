part of '../page.dart';

class _NoMediaTile extends StatelessWidget {
  const _NoMediaTile({
    this.onStartMusicApp,
    this.onLearnMore,
    this.onReEnableListener,
  });

  final void Function()? onStartMusicApp;
  final void Function()? onReEnableListener;
  final void Function()? onLearnMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.radio_outlined),
          onTap: onStartMusicApp,
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          title: Text(l10n.media_state_play_song),
        ),
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
                  onPressed: onLearnMore,
                  child: Text(
                    l10n.media_state_learn_more,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                onTap: onReEnableListener,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
