import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> downloadFile({required List<int> bytes, required String downloadName}) async {
  if(await _checkStoragePermission()) {
    late File file2;
    if(Platform.isIOS) {
      Directory? directory = await getApplicationDocumentsDirectory();
      file2 = File('${directory.path}/$downloadName');
    } else {
    file2 = File("/storage/emulated/0/Download/$downloadName");
    }
    await file2.writeAsBytes(bytes);
  }
}

Future<bool> _checkStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isGranted) {
    return true;
  }
  var requestStatus = await Permission.storage.request();
  final android = await DeviceInfoPlugin().androidInfo;
  if (android.version.sdkInt >= 33) {
    requestStatus = PermissionStatus.granted;
  }
  if (requestStatus.isGranted) {
    return true;
  }
  return false;
}