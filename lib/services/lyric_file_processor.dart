import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lrc.dart';
import '../models/lyric_model.dart';
import '../utils/logger.dart';
import 'db_helper.dart';

final lrcProcessorProvider = Provider((ref) {
  return LrcProcessor(ref);
});

class LrcProcessor {
  LrcProcessor(this.ref);

  final ProviderRef<Object?> ref;

  /// Returns a list of failed files if any
  Future<List<PlatformFile>> pickLrcFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['lrc'],
      withData: true,
    );

    if (result == null) return [];

    /// Seems compute cannot handle large amount of data
    /// so we need to split the data into batches
    const batchSize = 10;
    final batch = <PlatformFile>[];
    final failed = <PlatformFile>[];

    for (final item in result.files) {
      batch.add(item);
      if (batch.length == batchSize || item == result.files.last) {
        final result = await compute(processLrcFiles, batch);
        final lyrics = result.success;
        failed.addAll(result.failed);
        final ids = await ref.read(dbHelperProvider).addBatchLyrics(lyrics);
        logger.i('inserted ids: $ids');
        batch.clear();
      }
    }

    logger.e('failed: $failed');
    return failed;
  }
}

class LrcProcessResult {
  LrcProcessResult(this.success, this.failed);
  final List<LrcDB> success;
  final List<PlatformFile> failed;
}

Future<LrcProcessResult> processLrcFiles(List<PlatformFile> files) async {
  final lrcDbList = <LrcDB>[];
  final failed = <PlatformFile>[];

  for (final item in files) {
    if (item.path == null) continue;

    final fileNameWithExt = item.path!.split('/').last;
    final fileName = fileNameWithExt.split('.').first;

    final f = File(item.path!);
    final content = await f.readAsString();

    try {
      final processed = _sortLrc(content);
      final lrc = Lrc(processed);
      final title = lrc.title;
      final artist = lrc.artist;

      lrcDbList.add(LrcDB()
        ..fileName = fileName
        ..artist = artist
        ..title = title
        ..content = processed);
    } catch (e) {
      logger.e('Error processing file $fileName: $e');
      failed.add(item);
    }
  }
  logger.i('lyrics length: ${lrcDbList.length}');
  return LrcProcessResult(lrcDbList, failed);
}

String _sortLrc(String lrc) {
  final lines = lrc.split('\n');
  final newLines = [];
  for (final line in lines) {
    if (line.contains('[') && line.contains(']')) {
      final timeTags = line.substring(line.indexOf('['), line.lastIndexOf(']') + 1);
      final text = line.substring(line.lastIndexOf(']') + 1);
      final timeTagList = timeTags.split(']');
      for (final tag in timeTagList) {
        if (tag.isNotEmpty) newLines.add('$tag]$text');
      }
    } else {
      newLines.add(line);
    }
  }
  newLines.sort();
  return newLines.join('\n');
}
