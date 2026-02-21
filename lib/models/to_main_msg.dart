import 'package:freezed_annotation/freezed_annotation.dart';

part 'to_main_msg.freezed.dart';
part 'to_main_msg.g.dart';

@freezed
sealed class ToMainMsg with _$ToMainMsg {
  const factory ToMainMsg.closeOverlay() = CloseOverlay;

  factory ToMainMsg.fromJson(Map<String, dynamic> json) =>
      _$ToMainMsgFromJson(json);
}
