import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lyric_model.dart';
import '../../services/db_helper.dart';
import '../../services/lyric_file_processor.dart';
import '../../widgets/fail_import_dialog.dart';

class LyricListScreen extends ConsumerWidget {
  const LyricListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawLyrics = ref.watch(allRawLyricsProvider);

    return rawLyrics.when(
      error: (error, stackTrace) => Text('error: $error\n' 'stacktrace: $stackTrace'),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) => Scaffold(
        body: data.isEmpty
            ? const Center(child: Text('No lyrics found.'))
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => _LyricTile(
                  title: data[index].fileName,
                  onDelete: () => _promptDeleteDialog(context, ref, data[index]),
                ),
              ),
        bottomNavigationBar: _BottomBar(
          onDeleteAllPressed: () => _promptDeleteAllDialog(context, ref),
        ),
        floatingActionButton: _ImportFAB(
          onPressed: () => ref.read(lrcProcessorProvider).pickLrcFiles().then((failed) {
            if (failed.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => FailedImportDialog(failed),
              );
            }
            ref.invalidate(allRawLyricsProvider);
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      ),
    );
  }

  void _promptDeleteDialog(BuildContext context, WidgetRef ref, LrcDB lrcDB) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lyric'),
        content: const Text('Are you sure you want to delete this lyric?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(dbHelperProvider).deleteLyric(lrcDB).then((value) => ref.invalidate(allRawLyricsProvider));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _promptDeleteAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Lyric'),
        content: const Text('Are you sure you want to delete All lyrics?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(dbHelperProvider).deleteAllLyrics().then((value) => ref.invalidate(allRawLyricsProvider));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _LyricTile extends StatelessWidget {
  const _LyricTile({this.title, this.onDelete});

  final String? title;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Lyric'),
                  content: const Text('Are you sure you want to delete this lyric?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: onDelete,
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

class _ImportFAB extends StatelessWidget {
  const _ImportFAB({this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      hoverElevation: 16,
      onPressed: onPressed,
      label: const Text('Import'),
      icon: const Icon(Icons.add_rounded),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({this.onDeleteAllPressed});

  final void Function()? onDeleteAllPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      child: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Filter Lyric'),
                    content: const Text('Work in Progress'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.filter_alt_rounded),
              tooltip: 'Filter',
            ),
            IconButton(
              onPressed: onDeleteAllPressed,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete All',
            ),
          ],
        ),
      ),
    );
  }
}
