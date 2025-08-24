import 'dart:convert';
import 'package:web/web.dart';

Future<void> downloadFile({required List<int> bytes, required String downloadName}) async {
  
  if (bytes.isEmpty) return;
  final base64 = base64Encode(bytes);
  final anchorElement = HTMLAnchorElement()
  ..href = 'data:application/octet-stream;base64,$base64'
  ..setAttribute('download', downloadName);
  document.body!.append(anchorElement);
  anchorElement.click();
  anchorElement.remove();
  return;

}