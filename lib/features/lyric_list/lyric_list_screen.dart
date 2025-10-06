import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/app_router.dart';
import '../../models/lyric_model.dart';
import '../../widgets/fail_import_dialog.dart';
import '../../widgets/loading_widget.dart';
import 'bloc/lyric_list_bloc.dart';

class LyricListScreen extends StatelessWidget {
  const LyricListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LyricListView(),
      bottomNavigationBar: _BottomBar(
        onDeleteAllPressed: () => _promptDeleteAllDialog(context),
        onSearch: (v) => context.read<LyricListBloc>().add(SearchUpdated(v)),
      ),
      floatingActionButton: BlocListener<LyricListBloc, LyricListState>(
        listenWhen: (previous, current) =>
            previous.importStatus != current.importStatus,
        listener: (context, state) {
          switch (state.importStatus) {
            case LyricListImportStatus.initial:
            case LyricListImportStatus.importing:
              break;
            case LyricListImportStatus.error:
              showDialog(
                context: context,
                builder: (context) =>
                    FailedImportDialog(state.failedImportFiles),
              );
              break;
          }
        },
        child: Builder(
          builder: (context) {
            final importing = context.select(
              (LyricListBloc bloc) => bloc.state.importStatus.isImporting,
            );

            return FloatingActionButton(
              hoverElevation: 16,
              tooltip: 'Import',
              onPressed: importing
                  ? null
                  : () => context.read<LyricListBloc>().add(
                      const ImportLRCsRequested(),
                    ),
              child: importing ? const LoadingWidget() : const Icon(Icons.add),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  void _promptDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: context.read<LyricListBloc>(),
        child: BlocListener<LyricListBloc, LyricListState>(
          listener: (context, state) {
            switch (state.deleteStatus) {
              case LyricListDeleteStatus.initial:
                break;
              case LyricListDeleteStatus.deleted:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(const DeleteStatusHandled());
                break;
              case LyricListDeleteStatus.error:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(const DeleteStatusHandled());
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content: Text('Error deleting lyrics.'),
                  ),
                );
                break;
            }
          },
          child: AlertDialog(
            title: const Text('Delete All Lyric'),
            content: const Text('Are you sure you want to delete All lyrics?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => context.read<LyricListBloc>().add(
                  const DeleteAllRequested(),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LyricListView extends StatelessWidget {
  const LyricListView({super.key});

  @override
  Widget build(BuildContext context) {
    final lyrics = context.select<LyricListBloc, List<LrcModel>>(
      (bloc) => bloc.state.lyrics,
    );

    return lyrics.isEmpty
        ? const Center(child: Text('No lyrics found.'))
        : ListView.builder(
            itemCount: lyrics.length,
            itemBuilder: (context, index) => _LyricTile(
              title: lyrics[index].fileName,
              onTap: () => context.goNamed(
                AppRoute.localLyricDetail.name,
                pathParameters: {'id': lyrics[index].id},
              ),
              onDelete: () => _promptDeleteDialog(context, lyrics[index]),
            ),
          );
  }

  void _promptDeleteDialog(BuildContext context, LrcModel lrcModel) {
    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: context.read<LyricListBloc>(),
        child: BlocListener<LyricListBloc, LyricListState>(
          listenWhen: (previous, current) =>
              previous.deleteStatus != current.deleteStatus,
          listener: (context, state) {
            switch (state.deleteStatus) {
              case LyricListDeleteStatus.initial:
                break;
              case LyricListDeleteStatus.deleted:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(const DeleteStatusHandled());
                break;
              case LyricListDeleteStatus.error:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(const DeleteStatusHandled());
                showDialog(
                  context: context,
                  builder: (context) =>
                      const AlertDialog(content: Text('Error deleting lyric.')),
                );
                break;
            }
          },
          child: AlertDialog(
            title: const Text('Delete Lyric'),
            content: const Text('Are you sure you want to delete this lyric?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => context.read<LyricListBloc>().add(
                  DeleteRequested(lrcModel),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LyricTile extends StatelessWidget {
  const _LyricTile({this.title, this.onTap, this.onDelete});

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
