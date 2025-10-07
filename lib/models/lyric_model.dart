import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyric_model.freezed.dart';
part 'lyric_model.g.dart';

@freezed
@immutable
sealed class LrcModel with _$LrcModel {
  const factory LrcModel({
    required String id,
    String? fileName,
    String? content,
    String? title,
    String? artist,
  }) = _LrcModel;

  factory LrcModel.fromJson(Map<String, dynamic> json) =>
      _$LrcModelFromJson(json);
}
