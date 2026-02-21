part of '../page.dart';

class _LocalLyricTab extends StatelessWidget {
  const _LocalLyricTab();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(child: _LrcFormatInstruction()),
      floatingActionButton: _ImportFab(),
    );
  }
}

class _LrcFormatInstruction extends StatelessWidget {
  const _LrcFormatInstruction();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final txtTheme = Theme.of(context).textTheme;

    final activeMedia = context.select(
      (MediaListenerBloc b) => b.state.activeMediaState,
    );

    final title = activeMedia?.title ?? '';
    final artist = activeMedia?.artist ?? '';

    return Column(
      children: [
        ListTile(
          titleTextStyle: txtTheme.titleSmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
          title: Text(l10n.import_local_lrc_your_lrc_file_format),
        ),
        ListTile(
          title: Text(l10n.import_local_lrc_file_name_format_1),
          subtitle: SelectableText(
            '$title - $artist.lrc',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        ListTile(
          title: Text(l10n.import_local_lrc_file_name_format_2),
          subtitle: SelectableText(
            '$artist - $title.lrc',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        ListTile(
          title: Text(l10n.import_local_lrc_file_should_contain),
          subtitle: SelectableText(
            '[ti:$title]\n'
            '[ar:$artist]',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
      ],
    );
  }
}

class _ImportFab extends StatelessWidget {
  const _ImportFab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isProcessing = context.select<LocalLrcPickerBloc, bool>(
      (bloc) => bloc.state.status.isLoading,
    );

    return FloatingActionButton.extended(
      onPressed: isProcessing
          ? null
          : () => context.read<LocalLrcPickerBloc>().add(
              const LocalLrcPickerEvent.importLRCsRequested(),
            ),
      label: Text(
        isProcessing
            ? l10n.import_local_lrc_importing
            : l10n.import_local_lrc_import,
      ),
      icon: isProcessing
          ? const CircularProgressIndicator()
          : const Icon(Icons.drive_folder_upload_outlined),
    );
  }
}
