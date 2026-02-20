part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LyricListBloc, LyricListState>(
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
            }
          },
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
