// import 'dart:developer';

// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionManager extends GetxController {
//   Future<void> init() async {
//     _isSystemAlertWindowGranted.value = await Permission.systemAlertWindow.isGranted;

//     _isNotificationListenerGranted.value = await checkNotificationListenerPermission();
//   }


//   // reactive properties
//   final _isSystemAlertWindowGranted = false.obs;
//   final _isNotificationGranted = false.obs;
//   final _isNotificationListenerGranted = false.obs;

//   // getters
//   bool get isSystemAlertWindowGranted => _isSystemAlertWindowGranted.value;
//   bool get isNotificationGranted => _isNotificationGranted.value;
//   bool get isNotificationListenerGranted => _isNotificationListenerGranted.value;

//   set isNotificationListenerGranted(bool granted) => _isNotificationGranted.value = granted;

//   // methods:
//   void requestSystemAlertWindowPermission() {
//     Permission.systemAlertWindow
//         .request()
//         .then((value) => _isSystemAlertWindowGranted.value = value.isGranted);
//   }

//   Future<bool> checkNotificationListenerPermission() async {
//     bool result = await platform.invokeMethod('checkNotificationListenerPermission');

//     _isNotificationListenerGranted.value = result;
//     log('_isNotificationListenerGranted: ${_isNotificationListenerGranted.value}');

//     return result;
//   }

//   Future<void> requestNotificationListener() async {
//     try {
//       platform.invokeMethod('requestNotificationListenerPermission').then((_) {
//         log('ran here...');
//         checkNotificationListenerPermission();
//       });
//     } catch (e) {
//       log('error: $e');
//     }
//   }
// }
