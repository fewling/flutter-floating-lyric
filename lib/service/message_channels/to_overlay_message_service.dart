import 'dart:convert';
import 'dart:ui';

import '../../configs/main_overlay/main_overlay_port.dart';
import '../../models/to_overlay_msg_model.dart';
import '../../utils/logger.dart';

class ToOverlayMessageService {
  void sendMsg(ToOverlayMsgModel msg) {
    final json = jsonDecode(jsonEncode(msg.toJson()));

    final overlayPort = IsolateNameServer.lookupPortByName(MainOverlayPort.overlayPortName.key);
    if (overlayPort == null) {
      logger.e('Overlay port is null');
    } else {
      overlayPort.send(json);
    }
  }
}
