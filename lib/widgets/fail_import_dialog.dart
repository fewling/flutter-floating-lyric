import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/extensions/custom_extensions.dart';

class FailedImportDialog extends StatelessWidget {
  const FailedImportDialog(this.failedFiles, {super.key});

  final List<PlatformFile> failedFiles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.fail_import_dialog_title, maxLines: 1),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final file in failedFiles)
                Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text(
                l10n.fail_import_dialog_message,
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://en.wikipedia.org/wiki/LRC_(file_format)'),
                ),
                icon: const Icon(Icons.search),
                label: Text(l10n.fail_import_dialog_learn_more),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
