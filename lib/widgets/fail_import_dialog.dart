import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FailedImportDialog extends StatelessWidget {
  const FailedImportDialog(this.failedFiles, {super.key});

  final List<PlatformFile> failedFiles;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Failed to Import Files:',
        maxLines: 1,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final file in failedFiles)
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              const Text(
                'Please make sure the file is a valid .lrc file.',
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse(
                    'https://en.wikipedia.org/wiki/LRC_(file_format)')),
                icon: const Icon(Icons.search),
                label: const Text('Tap here to learn supported file formats.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
