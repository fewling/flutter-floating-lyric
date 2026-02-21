import 'dart:convert';
import 'dart:ui';

import '../../enums/main_overlay_port.dart';
import '../../models/to_main_msg.dart';
import '../../utils/logger.dart';

class ToMainMsgService {
  void sendMsg(ToMainMsg msg) {
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
