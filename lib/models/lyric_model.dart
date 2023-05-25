import 'package:isar/isar.dart';

part 'lyric_model.g.dart';

@collection
class LrcDB {
  Id id = Isar.autoIncrement;

  String? fileName;
  String? content;
  String? title;
  String? artist;
}
