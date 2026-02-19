import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../models/lyric_model.dart';
import '../../../utils/logger.dart';
import '../../../utils/lrc_builder.dart';
import '../../repos/persistence/local/local_db_repo.dart';

class LrcProcessorService {
  LrcProcessorService({required LocalDbRepo localDB}) {
    _localDB = localDB;
  }

  late final LocalDbRepo _localDB;

  /// Returns a list of failed files if any
  Future<List<PlatformFile>> pickLrcFiles() async {
    final result = await FilePicker.platform.pickFiles(
      // type: FileType.custom,
      allowMultiple: true,
      // allowedExtensions: ['lrc'],
      withData: true,
    );

    if (result == null) return [];

    /// Seems compute cannot handle large amount of data
    /// so we need to split the data into batches
    const batchSize = 10;
    final batch = <PlatformFile>[];
    final failed = <PlatformFile>[];

    for (final item in result.files) {
      if (!item.name.endsWith('.lrc')) continue;

      batch.add(item);
      if (batch.length == batchSize || item == result.files.last) {
        final result = await compute(processLrcFiles, batch);
        final lyrics = result.success;
        failed.addAll(result.failed);
        await _localDB.addBatchLyrics(lyrics);
        batch.clear();
      }
    }

    logger.e('failed: $failed');
    return failed;
  }
}

class LrcProcessResult {
  LrcProcessResult(this.success, this.failed);
  final List<LrcModel> success;
  final List<PlatformFile> failed;
}

Future<LrcProcessResult> processLrcFiles(List<PlatformFile> files) async {
  final lrcDbList = <LrcModel>[];
  final failed = <PlatformFile>[];

  for (final item in files) {
    if (item.path == null) continue;

    final fileNameWithExt = item.path!.split('/').last;
    final fileName = fileNameWithExt.split('.lrc').first;

    final f = File(item.path!);
    final content = await f.readAsString();

    try {
      final processed = _sortLrc(content);
      final lrc = LrcBuilder().buildLrc(processed);
      final title = lrc.title;
      final artist = lrc.artist;

      // ! Same as [local_db_service.dart]
      final digest = sha256.convert(utf8.encode('$title$artist$content'));
      final id = digest.toString();

      lrcDbList.add(
        LrcModel(
          id: id,
          fileName: fileName,
          artist: artist,
          title: title,
          content: processed,
        ),
      );
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
      final timeTags = line.substring(
        line.indexOf('['),
        line.lastIndexOf(']') + 1,
      );
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
