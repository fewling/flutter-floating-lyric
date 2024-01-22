import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/lyric_model.dart';
import '../../../widgets/fail_import_dialog.dart';
import 'lyric_list_filter_notifier.dart';
import 'lyric_list_notifier.dart';

class LyricListScreen extends StatelessWidget {
  const LyricListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LyricListView(),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) => _BottomBar(
          onDeleteAllPressed: () => _promptDeleteAllDialog(context, ref),
          onSearch:
              ref.read(lyricListFilterNotifierProvider.notifier).setSearchTerm,
        ),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) => FloatingActionButton(
          hoverElevation: 16,
          tooltip: 'Import',
          child: const Icon(Icons.add),
          onPressed: () => ref
              .read(lyricListNotifierProvider.notifier)
              .importFiles()
              .then((failed) {
            if (failed.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => FailedImportDialog(failed),
              );
            }
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
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
            onPressed: context.pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => ref
                .read(lyricListNotifierProvider.notifier)
                .deleteAllLyrics()
                .then((value) => context.pop()),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class LyricListView extends ConsumerWidget {
  const LyricListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyricsAsync = ref.watch(lyricListNotifierProvider);
    return lyricsAsync.when(
      data: (data) {
        final lyrics = data.lyrics;
        return lyrics.isEmpty
            ? const Center(child: Text('No lyrics found.'))
            : ListView.builder(
                itemCount: lyrics.length,
                itemBuilder: (context, index) => _LyricTile(
                  title: lyrics[index].fileName,
                  onTap: () => ref
                      .read(lyricListNotifierProvider.notifier)
                      .editLyric(lyrics[index]),
                  onDelete: () => _promptDeleteDialog(
                    context,
                    ref,
                    lyrics[index],
                  ),
                ),
              );
      },
      error: (error, stackTrace) => SelectableText(
        'Please contact the developer.\n'
        'error: $error\n'
        'stacktrace: $stackTrace',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
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
            onPressed: context.pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => ref
                .read(lyricListNotifierProvider.notifier)
                .deleteLyric(lrcDB)
                .then((value) => context.pop()),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _LyricTile extends StatelessWidget {
  const _LyricTile({
    this.title,
    this.onTap,
    this.onDelete,
  });

  final String? title;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(title ?? ''),
      trailing: IconButton(
        onPressed: onDelete,
        icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
        tooltip: 'Delete',
      ),
    );
  }
}

class _BottomBar extends StatefulWidget {
  const _BottomBar({this.onDeleteAllPressed, required this.onSearch});

  final void Function(String value) onSearch;
  final void Function()? onDeleteAllPressed;

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      child: BottomAppBar(
        child: Row(
          children: [
            Flexible(
              child: AnimatedCrossFade(
                firstChild: IconButton(
                  onPressed: () => setState(() => _isSearching = true),
                  icon: Icon(_isSearching ? Icons.search_off : Icons.search),
                  tooltip: 'Search',
                ),
                secondChild: TextField(
                  onChanged: widget.onSearch,
                  decoration: InputDecoration(
                    icon: IconButton.filledTonal(
                      onPressed: () => setState(() => _isSearching = false),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    hintText: 'Filename',
                    border: InputBorder.none,
                  ),
                ),
                crossFadeState: _isSearching
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
            IconButton(
              onPressed: widget.onDeleteAllPressed,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete All',
            ),
          ],
        ),
      ),
    );
  }
}
