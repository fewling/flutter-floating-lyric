import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/db_helper.dart';
import '../../services/lyric_file_processor.dart';
import '../../widgets/fail_import_dialog.dart';

class LyricListScreen extends ConsumerWidget {
  const LyricListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawLyrics = ref.watch(allRawLyricsProvider);

    return rawLyrics.when(
      data: (data) => Scaffold(
        body: data.isEmpty
            ? const Center(child: Text('No lyrics found.'))
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].fileName ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(dbHelperProvider)
                            .deleteLyric(data[index])
                            .then((value) =>
                                ref.invalidate(allRawLyricsProvider)),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          child: BottomAppBar(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt_rounded),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(dbHelperProvider)
                      .deleteAllLyrics()
                      .then((value) => ref.invalidate(allRawLyricsProvider)),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          hoverElevation: 16,
          onPressed: () =>
              ref.read(lrcProcessorProvider).pickLrcFiles().then((failed) {
            if (failed.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => FailedImportDialog(failed),
              );
            }
          }),
          child: const Icon(Icons.add_rounded),
        ),
      ),
      error: (error, stackTrace) =>
          Text('error: $error\nstacktrace: $stackTrace'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
