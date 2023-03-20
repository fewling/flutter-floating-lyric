import 'package:flutter/services.dart';

const platform = MethodChannel('floating_lyric/method_channel');

enum PlatformMethods {
  checkNotificationListenerPermission,
  requestNotificationListenerPermission,
}
