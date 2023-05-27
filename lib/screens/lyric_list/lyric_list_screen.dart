import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/lyric_model.dart';
import '../../services/db_helper.dart';
import '../../services/lyric_file_processor.dart';
import '../../widgets/fail_import_dialog.dart';

final _isLoadingProvider = StateProvider((_) => false);
final _filterProvider = StateProvider.autoDispose((_) => '');

class LyricListScreen extends ConsumerWidget {
  const LyricListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawLyrics = ref.watch(allRawLyricsProvider);

    return rawLyrics.when(
      error: (error, stackTrace) => Text(
        'Please contact the developer.\n'
        'error: $error\n'
        'stacktrace: $stackTrace',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        final filter = ref.watch(_filterProvider);
        if (filter.isNotEmpty) {
          data = data
              .where(
                  (element) => element.fileName!.toLowerCase().contains(filter))
              .toList();
        }
        return Scaffold(
          body: data.isEmpty
              ? const Center(child: Text('No lyrics found.'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => _LyricTile(
                    title: data[index].fileName,
                    onDelete: () => _promptDeleteDialog(
                      context,
                      ref,
                      data[index],
                    ),
                  ),
                ),
          bottomNavigationBar: _BottomBar(
            onDeleteAllPressed: () => _promptDeleteAllDialog(context, ref),
            onSearch: (value) =>
                ref.read(_filterProvider.notifier).state = value,
          ),
          floatingActionButton: _ImportFAB(
              isLoading: ref.watch(_isLoadingProvider),
              onPressed: () {
                ref.read(_isLoadingProvider.notifier).state = true;
                ref.read(lrcProcessorProvider).pickLrcFiles().then((failed) {
                  ref.read(_isLoadingProvider.notifier).state = false;

                  if (failed.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => FailedImportDialog(failed),
                    );
                  }
                  ref.invalidate(allRawLyricsProvider);
                });
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
        );
      },
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
              ref
                  .read(dbHelperProvider)
                  .deleteLyric(lrcDB)
                  .then((value) => ref.invalidate(allRawLyricsProvider));
              Navigator.of(context).pop();
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
              ref
                  .read(dbHelperProvider)
                  .deleteAllLyrics()
                  .then((value) => ref.invalidate(allRawLyricsProvider));
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
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(title ?? ''),
      trailing: IconButton(
        onPressed: onDelete,
        icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
        tooltip: 'Delete',
      ),
    );
  }
}

class _ImportFAB extends StatelessWidget {
  const _ImportFAB({this.onPressed, this.isLoading = false});

  final void Function()? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      hoverElevation: 16,
      onPressed: onPressed,
      tooltip: 'Import',
      child:
          isLoading ? const CircularProgressIndicator() : const Icon(Icons.add),
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
                  onChanged: (value) => widget.onSearch(value),
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
