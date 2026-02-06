import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/local/local_db_repo.dart';
import '../../service/lrc/lrc_process_service.dart';
import '../../utils/extensions/custom_extensions.dart';
import '../../widgets/fail_import_dialog.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import 'bloc/import_local_lrc_bloc.dart';

class ImportLocalLrc extends StatelessWidget {
  const ImportLocalLrc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportLocalLrcBloc(
        lrcProcessorService: LrcProcessorService(
          localDB: context.read<LocalDbRepo>(),
        ),
      )..add(const ImportLocalLrcStarted()),
      child: const Scaffold(
        body: SingleChildScrollView(child: _LrcFormatInstruction()),
        floatingActionButton: _ImportFab(),
      ),
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

    final title = context.select<LyricStateListenerBloc, String>(
      (bloc) => bloc.state.mediaState?.title ?? '',
    );

    final artist = context.select<LyricStateListenerBloc, String>(
      (bloc) => bloc.state.mediaState?.artist ?? '',
    );

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
    final isProcessing = context.select<ImportLocalLrcBloc, bool>(
      (bloc) => bloc.state.status.isProcessingFiles,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ImportLocalLrcBloc, ImportLocalLrcState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case ImportLocalLrcStatus.initial:
              case ImportLocalLrcStatus.processingFiles:
                break;
              case ImportLocalLrcStatus.success:
              case ImportLocalLrcStatus.failed:
                if (state.failedFiles.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => FailedImportDialog(state.failedFiles),
                  );
                }
                context.read<LyricStateListenerBloc>().add(
                  const NewLyricSaved(),
                );
                context.read<ImportLocalLrcBloc>().add(
                  const ImportStatusHandled(),
                );
            }
          },
        ),
      ],
      child: FloatingActionButton.extended(
        onPressed: isProcessing
            ? null
            : () => context.read<ImportLocalLrcBloc>().add(
                const ImportLRCsRequested(),
              ),
        label: Text(
          isProcessing
              ? l10n.import_local_lrc_importing
              : l10n.import_local_lrc_import,
        ),
        icon: isProcessing
            ? const CircularProgressIndicator()
            : const Icon(Icons.drive_folder_upload_outlined),
      ),
    );
  }
}
