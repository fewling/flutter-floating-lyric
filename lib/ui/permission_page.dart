import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:floating_lyric/singletons/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    final manager = Get.find<PermissionManager>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('This app needs permission(s) below:'),
            const SizedBox(height: 16),
            Obx(
              () => ElevatedButton.icon(
                onPressed: manager.isSystemAlertWindowGranted
                    ? null
                    : () => manager.requestSystemAlertWindowPermission(),
                icon: Icon(manager.isSystemAlertWindowGranted
                    ? Icons.check
                    : Icons.unpublished_outlined),
                label: const Text('System Alert Window'),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ElevatedButton.icon(
                onPressed: manager.isNotificationGranted
                    ? null
                    : () => manager.requestNotificationPermission(),
                icon: Icon(manager.isNotificationGranted
                    ? Icons.check
                    : Icons.unpublished_outlined),
                label: const Text('Notification'),
              ),
            ),

            /// For testing notifications:
            ElevatedButton(
              onPressed: () {
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 0,
                    channelKey: 'basic_channel',
                    body: 'This is a test notification',
                    title: 'Test notification',
                    color: Colors.deepPurple,
                  ),
                );
              },
              child: const Text('test'),
            ),
          ],
        ),
      ),
    );
  }
}
