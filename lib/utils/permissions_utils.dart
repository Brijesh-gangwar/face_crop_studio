import 'package:permission_handler/permission_handler.dart';

class PermissionsUtils {
  static Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }
}
