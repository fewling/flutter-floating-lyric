import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric.freezed.dart';
part 'lyric.g.dart';

@freezed
class Lyric with _$Lyric {
  const factory Lyric({
    @Default('') String singer,
    @Default('') String song,
    @Default(<String>[]) List<String> content,
  }) = _Lyric;

  factory Lyric.fromJson(Map<String, dynamic> json) => _$LyricFromJson(json);
}
