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
          ],
        ),
      ),
    );
  }
}
