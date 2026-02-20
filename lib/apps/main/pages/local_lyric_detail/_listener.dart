part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LyricDetailBloc, LyricDetailState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus,
          listener: (context, state) {
            switch (state.saveStatus) {
              case LyricSaveStatus.initial:
                return;
              case LyricSaveStatus.saved:
                _showSuccess(context);
              case LyricSaveStatus.error:
                _showError(context);
            }
            context.read<LyricDetailBloc>().add(
              const LyricDetailEvent.saveStatusReset(),
            );
          },
        ),
      ],
      child: Builder(builder: builder),
    );
  }

  void _showError(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Text(
              l10n.lyric_detail_error_saving_lyric,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ],
        ),
        backgroundColor: colorScheme.errorContainer,
        closeIconColor: colorScheme.onErrorContainer,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.primaryContainer,
        closeIconColor: colorScheme.onPrimaryContainer,
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.lyric_detail_lyric_saved,
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
