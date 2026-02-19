part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: const LyricListView(),
      bottomNavigationBar: _BottomBar(
        onDeleteAllPressed: () => _promptDeleteAllDialog(context),
        onSearch: (v) =>
            context.read<LyricListBloc>().add(LyricListEvent.searchUpdated(v)),
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
              tooltip: l10n.lyric_list_import,
              onPressed: importing
                  ? null
                  : () => context.read<LyricListBloc>().add(
                      const LyricListEvent.importLRCsRequested(),
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
    final l10n = context.l10n;
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
                context.read<LyricListBloc>().add(
                  const LyricListEvent.deleteStatusHandled(),
                );
                break;
              case LyricListDeleteStatus.error:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(
                  const LyricListEvent.deleteStatusHandled(),
                );
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(l10n.lyric_list_error_deleting_lyrics),
                  ),
                );
                break;
            }
          },
          child: AlertDialog(
            title: Text(l10n.lyric_list_delete_all_title),
            content: Text(l10n.lyric_list_delete_all_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(l10n.lyric_list_cancel),
              ),
              TextButton(
                onPressed: () => context.read<LyricListBloc>().add(
                  const LyricListEvent.deleteAllRequested(),
                ),
                child: Text(l10n.lyric_list_delete),
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
    final l10n = context.l10n;
    final lyrics = context.select<LyricListBloc, List<LrcModel>>(
      (bloc) => bloc.state.lyrics,
    );

    return lyrics.isEmpty
        ? Center(child: Text(l10n.lyric_list_no_lyrics_found))
        : RefreshIndicator(
            onRefresh: () async => context.read<LyricListBloc>().add(
              const LyricListEvent.started(),
            ),
            child: ListView.builder(
              itemCount: lyrics.length,
              itemBuilder: (context, index) => _LyricTile(
                title: lyrics[index].fileName,
                onTap: () => context.goNamed(
                  MainAppRoutes.localLyricDetail.name,
                  pathParameters: {'id': lyrics[index].id},
                ),
                onDelete: () => _promptDeleteDialog(context, lyrics[index]),
              ),
            ),
          );
  }

  void _promptDeleteDialog(BuildContext context, LrcModel lrcModel) {
    final l10n = context.l10n;
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
                context.read<LyricListBloc>().add(
                  const LyricListEvent.deleteStatusHandled(),
                );
                break;
              case LyricListDeleteStatus.error:
                Navigator.of(dialogCtx).pop();
                context.read<LyricListBloc>().add(
                  const LyricListEvent.deleteStatusHandled(),
                );
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(l10n.lyric_list_error_deleting_lyric),
                  ),
                );
                break;
            }
          },
          child: AlertDialog(
            title: Text(l10n.lyric_list_delete_title),
            content: Text(l10n.lyric_list_delete_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(l10n.lyric_list_cancel),
              ),
              TextButton(
                onPressed: () => context.read<LyricListBloc>().add(
                  LyricListEvent.deleteRequested(lrcModel),
                ),
                child: Text(l10n.lyric_list_delete),
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
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(title ?? ''),
      trailing: IconButton(
        onPressed: onDelete,
        icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
        tooltip: l10n.lyric_list_delete,
      ),
    );
  }
}

class _BottomBar extends StatefulWidget {
  const _BottomBar({required this.onSearch, this.onDeleteAllPressed});

  final void Function(String value) onSearch;
  final void Function()? onDeleteAllPressed;

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                  tooltip: l10n.lyric_list_search,
                ),
                secondChild: TextField(
                  onChanged: widget.onSearch,
                  decoration: InputDecoration(
                    icon: IconButton.filledTonal(
                      onPressed: () => setState(() => _isSearching = false),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    hintText: l10n.lyric_list_filename,
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
              tooltip: l10n.lyric_list_delete_all,
            ),
          ],
        ),
      ),
    );
  }
}
