part of '../page.dart';

class _MediaStateCard extends StatelessWidget {
  const _MediaStateCard({required this.mediaState});

  final MediaState mediaState;

  @override
  Widget build(BuildContext context) {
    final mediaAppName = mediaState.mediaPlayerName;
    final title = mediaState.title;
    final artist = mediaState.artist;
    final position = mediaState.position.toInt();
    final duration = mediaState.duration.toInt();
    final progress = position / duration;

    return ListTile(
      leading: const Icon(Icons.radio_outlined),
      title: Text.rich(
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
      ),
      subtitle: LinearProgressIndicator(
        value: progress.isInfinite || progress.isNaN ? 0 : progress,
      ),
    );
  }
}
