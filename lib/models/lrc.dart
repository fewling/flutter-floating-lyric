import 'package:freezed_annotation/freezed_annotation.dart';

part 'lrc.freezed.dart';
part 'lrc.g.dart';

@freezed
class Lrc with _$Lrc {
  const factory Lrc({
    String? artist,
    String? title,
    String? album,
    String? creator,
    String? author,
    String? program,
    String? version,
    @Default(<LrcLine>[]) List<LrcLine> lines,
  }) = _Lrc;

  factory Lrc.fromJson(Map<String, dynamic> json) => _$LrcFromJson(json);
}

@freezed
class LrcLine with _$LrcLine {
  const factory LrcLine({required Duration time, required String content}) =
      _LrcLine;

  factory LrcLine.fromJson(Map<String, dynamic> json) =>
      _$LrcLineFromJson(json);
}
