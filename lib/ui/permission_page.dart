import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:floating_lyric/singletons/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final _manager = PermissionManager();

  @override
  Widget build(BuildContext context) {
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
                onPressed: _manager.isSystemAlertWindowGranted
                    ? null
                    : () => _manager.requestSystemAlertWindowPermission(),
                icon: Icon(_manager.isSystemAlertWindowGranted
                    ? Icons.check
                    : Icons.unpublished_outlined),
                label: const Text('System Alert Window'),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ElevatedButton.icon(
                onPressed: _manager.isNotificationGranted
                    ? null
                    : () => _manager.requestNotificationPermission(),
                icon: Icon(_manager.isNotificationGranted
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
