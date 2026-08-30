import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


// Future<void> downloadFile({required List<int> bytes, required String downloadName}) async {
//   if(await _checkStoragePermission()) {
//     late File file2;
//     if(Platform.isIOS) {
//       Directory? directory = await getApplicationDocumentsDirectory();
//       file2 = File('${directory.path}/$downloadName');
//     } else {
//       // file2 = File("/storage/emulated/0/Download/$downloadName");
//       final dir = await getDownloadsDirectory(); // ✅ Works Android 10+
//       if (dir == null) throw Exception("Downloads directory not available");
//       file2 = File('${dir.path}/$downloadName');
//     }
//     await file2.writeAsBytes(bytes);
//   }
// }

Future<void> downloadFile({
  required List<int> bytes,
  required String downloadName,
}) async {
  // --- iOS: save to app's Documents directory ---
  if (Platform.isIOS) {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$downloadName');
    await file.writeAsBytes(bytes);
    return;
  }

  // --- Android ---
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 29) {
      final mediaStore = MediaStore(); // ensureInitialized() already done in main()
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$downloadName');
      await tempFile.writeAsBytes(bytes);

      final result = await mediaStore.saveFile(
        tempFilePath: tempFile.path,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (result == null) {
        throw Exception('Failed to save file to Downloads (MediaStore)');
      }
    } else {
      // Android 9 and below (API ≤ 28): legacy permission + direct path
      final granted = await _requestLegacyStoragePermission();
      if (!granted) {
        throw Exception('Storage permission denied');
      }

      final file = File('/storage/emulated/0/Download/$downloadName');
      await file.writeAsBytes(bytes);
    }
    return;
  }

  throw UnsupportedError('Unsupported platform for downloadFile');
}

/// Only relevant for Android SDK <= 28 (Android 9 and below)
Future<bool> _requestLegacyStoragePermission() async {
  final status = await Permission.storage.status;
  if (status.isGranted) return true;

  final requestStatus = await Permission.storage.request();
  return requestStatus.isGranted;
}

// Future<bool> _checkStoragePermission() async {
//   final android = await DeviceInfoPlugin().androidInfo;

//   if (android.version.sdkInt >= 33) {
//     return true;
//   }

//   final status = await Permission.storage.status;
//   if (status.isGranted) return true;

//   final requestStatus = await Permission.storage.request();
//   return requestStatus.isGranted;
// }