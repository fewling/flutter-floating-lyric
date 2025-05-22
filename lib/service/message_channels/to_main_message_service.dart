import 'dart:convert';
import 'dart:ui';

import '../../configs/main_overlay/main_overlay_port.dart';
import '../../models/from_overlay_msg_model.dart';
import '../../utils/logger.dart';

class ToMainMessageService {
  void sendMsg(FromOverlayMsgModel msg) {
    final json = jsonDecode(jsonEncode(msg.toJson()));

    final mainPort = IsolateNameServer.lookupPortByName(
      MainOverlayPort.mainPortName.key,
    );
    if (mainPort == null) {
      logger.e('Main port is null');
    } else {
      mainPort.send(json);
    }
  }
}
