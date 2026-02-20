import 'dart:isolate';
import 'dart:ui';

import '../utils/logger.dart';

mixin IsolatesMixin {
  Future<bool> registerPort(SendPort sendPort, String portName) async {
    var count = 0;
    var isRegistered = IsolateNameServer.registerPortWithName(
      sendPort,
      portName,
    );
    while (!isRegistered) {
      logger.d('Retrying to register port with name $portName (count: $count)');

      await Future.delayed(const Duration(milliseconds: 100));
      count++;

      IsolateNameServer.removePortNameMapping(portName);

      isRegistered = IsolateNameServer.registerPortWithName(sendPort, portName);

      if (count > 100) {
        logger.e('Failed to unregister port with name $portName');
        break;
      }
    }

    if (!isRegistered) {
      logger.e('Failed to register port with name $portName');
    } else {
      logger.t('Registered port with name $portName');
    }

    return isRegistered;
  }
}
