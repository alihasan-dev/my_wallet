import 'dart:convert';
import 'package:web/web.dart';

Future<void> downloadFile({required List<int> bytes, required String downloadName}) async {

  final base64 = base64Encode(bytes);
  final anchorElement = HTMLAnchorElement()
  ..href = 'data:application/octet-stream;base64,$base64'
  ..setAttribute('download', downloadName);
  document.body!.append(anchorElement);
  anchorElement.click();
  anchorElement.remove();
  return;
  
  ///Deprecated code using dart:html
  // // Encode our file in base64
  // final base64 = base64Encode(bytes);
  // // Create the link with the file
  // final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$base64')
  //     ..target = 'blank'
  //     ..download = downloadName;
  // // trigger download
  // document.body!.append(anchor);
  // anchor.click();
  // anchor.remove();
  // return;
}