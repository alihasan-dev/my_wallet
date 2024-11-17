import 'dart:convert';
import 'dart:html';

String getPlatformSpecificText() => 'This is running on the Web';


Future<void> downloadFile({required List<int> bytes, required String downloadName}) async {
  // Encode our file in base64
  final base64 = base64Encode(bytes);
  // Create the link with the file
  final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$base64')
      ..target = 'blank';
  anchor.download = downloadName;
  // trigger download
  document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}