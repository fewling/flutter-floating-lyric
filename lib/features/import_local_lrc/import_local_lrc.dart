import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/local/local_db_repo.dart';
import '../../service/lrc/lrc_process_service.dart';
import '../../widgets/fail_import_dialog.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import 'bloc/import_local_lrc_bloc.dart';

class ImportLocalLrc extends StatelessWidget {
  const ImportLocalLrc({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final txtTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => ImportLocalLrcBloc(
        lrcProcessorService: LrcProcessorService(
          localDB: context.read<LocalDbRepo>(),
        ),
      )..add(const ImportLocalLrcStarted()),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              titleTextStyle: txtTheme.titleSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
              title: const Text(
                'Your LRC file should match one of the following formats:',
              ),
            ),
            Builder(
              builder: (context) {
                final title = context.select<LyricStateListenerBloc, String>(
                  (bloc) => bloc.state.mediaState?.title ?? '',
                );

                final artist = context.select<LyricStateListenerBloc, String>(
                  (bloc) => bloc.state.mediaState?.artist ?? '',
                );

                return Column(
                  children: [
                    ListTile(
                      title: const Text('1. File name should be:'),
                      subtitle: SelectableText(
                        '$title - $artist.lrc',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ),
                    ListTile(
                      title: const Text('2. File name should be:'),
                      subtitle: SelectableText(
                        '$artist - $title.lrc',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ),
                    ListTile(
                      title: const Text('3. File should contain:'),
                      subtitle: SelectableText(
                        '[ti:$title]\n'
                        '[ar:$artist]',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ),
                  ],
                );
              },
            ),
            Builder(
              builder: (context) {
                final isProcessing = context.select<ImportLocalLrcBloc, bool>(
                  (bloc) => bloc.state.isProcessingFiles,
                );

                return isProcessing
                    ? ElevatedButton.icon(
                        onPressed: null,
                        icon: const Center(child: CircularProgressIndicator()),
                        label: const Text('Importing...'),
                      )
                    : BlocListener<ImportLocalLrcBloc, ImportLocalLrcState>(
                        listenWhen: (previous, current) => previous.failedFiles != current.failedFiles,
                        listener: (context, state) {
                          if (state.failedFiles.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => FailedImportDialog(state.failedFiles),
                            );
                          }
                        },
                        child: ElevatedButton.icon(
                          onPressed: () => context.read<ImportLocalLrcBloc>().add(const ImportLRCsRequested()),
                          icon: const Icon(Icons.drive_folder_upload_outlined),
                          label: const Text('Import'),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
