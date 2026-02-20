import 'dart:convert';
import 'dart:ui';

import '../../enums/main_overlay_port.dart';
import '../../models/to_overlay_msg_model.dart';
import '../../utils/logger.dart';

class ToOverlayMsgService {
  void sendMsg(ToOverlayMsgModel msg) {
    final json = jsonDecode(jsonEncode(msg.toJson()));
    _sendJson(json as Map<String, dynamic>);
  }

  void sendWindowConfig(ToOverlayMsgConfig config) => _sendJson(
    jsonDecode(jsonEncode(config.toJson())) as Map<String, dynamic>,
  );

  void sendMediaState(ToOverlayMsgMediaState mediaState) => _sendJson(
    jsonDecode(jsonEncode(mediaState.toJson())) as Map<String, dynamic>,
  );

  void _sendJson(Map<String, dynamic> json) {
    final overlayPort = IsolateNameServer.lookupPortByName(
      MainOverlayPort.overlayPortName.key,
    );
    if (overlayPort == null) {
      logger.e('Overlay port is null');
    } else {
      overlayPort.send(json);
    }
  }
}
