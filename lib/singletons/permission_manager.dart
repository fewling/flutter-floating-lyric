import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager extends GetxController {
  Future<void> init() async {
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
}
