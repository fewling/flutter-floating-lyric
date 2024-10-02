import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'from_overlay_msg_model.freezed.dart';
part 'from_overlay_msg_model.g.dart';

@freezed
class FromOverlayMsgModel with _$FromOverlayMsgModel {
  const factory FromOverlayMsgModel({
    @JsonKey(
      fromJson: _overlayActionFromJson,
      toJson: _overlayActionToJson,
    )
    OverlayAction? action,
  }) = _FromOverlayMsgModel;

  factory FromOverlayMsgModel.fromJson(Map<String, dynamic> json) => _$FromOverlayMsgModelFromJson(json);
}

enum OverlayAction {
  minimize('MINIMIZE'),
  close('CLOSE'),
  windowTouched('WINDOW_TOUCHED');

  const OverlayAction(this.key);

  final String key;
}

OverlayAction _overlayActionFromJson(String? value) {
  return OverlayAction.values.firstWhereOrNull((e) => e.key == value) ?? OverlayAction.close;
}

String? _overlayActionToJson(OverlayAction? action) => action?.key;

extension OverlayActionX on OverlayAction {
  bool get isMinimize => this == OverlayAction.minimize;
  bool get isClose => this == OverlayAction.close;
  bool get isWindowTouched => this == OverlayAction.windowTouched;
}
