import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager extends GetxController {
  Future<void> init() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Colors.deepPurple,
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);

    AwesomeNotifications().actionStream.listen((receivedNotification) =>
        log('Received notification: ${receivedNotification.title}'));

    _isNotificationGranted.value =
        await AwesomeNotifications().isNotificationAllowed();

    _isSystemAlertWindowGranted.value =
        await Permission.systemAlertWindow.isGranted;
  }

  // reactive properties
  final _isSystemAlertWindowGranted = false.obs;
  final _isNotificationGranted = false.obs;

  // getters
  bool get isSystemAlertWindowGranted => _isSystemAlertWindowGranted.value;
  bool get isNotificationGranted => _isNotificationGranted.value;

  // methods:
  void requestSystemAlertWindowPermission() {
    Permission.systemAlertWindow
        .request()
        .then((value) => _isSystemAlertWindowGranted.value = value.isGranted);
  }

  void requestNotificationPermission() {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
