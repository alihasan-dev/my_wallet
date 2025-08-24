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
      // file2 = File("/storage/emulated/0/Download/$downloadName");
      final dir = await getDownloadsDirectory(); // ✅ Works Android 10+
      if (dir == null) throw Exception("Downloads directory not available");
      file2 = File('${dir.path}/$downloadName');
    }
    await file2.writeAsBytes(bytes);
  }
}

Future<bool> _checkStoragePermission() async {
  final android = await DeviceInfoPlugin().androidInfo;

  if (android.version.sdkInt >= 33) {
    return true;
  }

  final status = await Permission.storage.status;
  if (status.isGranted) return true;

  final requestStatus = await Permission.storage.request();
  return requestStatus.isGranted;
}