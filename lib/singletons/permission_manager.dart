import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager extends GetxController {
  // singleton constructor
  factory PermissionManager() => _instance;
  static final PermissionManager _instance = PermissionManager._();
  PermissionManager._();

  Future<void> init() async {
    _isSystemAlertWindowGranted.value =
        await Permission.systemAlertWindow.isGranted;
  }

  // reactive properties
  final _isSystemAlertWindowGranted = false.obs;

  // getters
  bool get isSystemAlertWindowGranted => _isSystemAlertWindowGranted.value;

  // methods:
  void requestSystemAlertWindowPermission() {
    Permission.systemAlertWindow
        .request()
        .then((value) => _isSystemAlertWindowGranted.value = value.isGranted);
  }
}
