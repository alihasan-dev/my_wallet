import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:my_wallet/utils/app_extension_method.dart';
import 'package:web/web.dart' hide ResponseType;

Future<void> downloadFile({
  List<int>? bytes,
  required String downloadName,
  String? networkUrl
}) async {
  // --- Download file from network ---
  if (!(networkUrl ?? '').isBlank) {
    bytes = await downloadNetworkFile(networkUrl!);
  }
  ///check for bytes availability
  if ((bytes ?? []).isEmpty) return;
  
  final base64 = base64Encode(bytes!);
  final anchorElement = HTMLAnchorElement()
  ..href = 'data:application/octet-stream;base64,$base64'
  ..setAttribute('download', downloadName);
  document.body!.append(anchorElement);
  anchorElement.click();
  anchorElement.remove();
  return;
}

Future<List<int>?> downloadNetworkFile(String fileUrl) async {
  try {
    final dio = Dio();
    final response = await dio.get<List<int>>(
      fileUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  } catch (e) {
    return null;
  }
}