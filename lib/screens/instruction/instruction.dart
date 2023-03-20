import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/floating_window_state.dart';
import '../../service/song_box.dart';

class InstructionPage extends ConsumerWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingState = ref.watch(floatingStateProvider);
    final floatingStateNotifier = ref.watch(floatingStateProvider.notifier);

    final songBox = SongBox();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.notes_outlined),
        title: const Text('How to use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ListTile(
              title: const Text('1. Start your music app and play a song.'),
              subtitle: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Currently playing: ${floatingState.displayingTitle}'),
                    const SizedBox(height: 8),
                    Text('Expected file: ${floatingState.displayingTitle}.lrc'),
                  ],
                ),
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('2. Tap to show floating window'),
              ),
              value: floatingState.shouldShowWindow,
              onChanged: floatingStateNotifier.toggleWindowVisibility,
            ),
            const Divider(),
            ListTile(
              title: const Text('3. Tap to import LRC files from a folder'),
              trailing: const Icon(Icons.chevron_right_outlined),
              onTap: () => songBox.importLRC(),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                '4. If you have completed steps 1 ~ 3, yet the window is not showing the lyric, try switch to another song then switch back.',
              ),
            ),
            const Divider(),
            Text(
              'Format of synchroized <.LRC> file',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
            ),
            Image.asset('assets/images/sample_lrc_file.png'),
          ],
        ),
      ),
    );
  }
}
