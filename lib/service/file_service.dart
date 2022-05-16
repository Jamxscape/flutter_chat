import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '/config/net/app_dio.dart';
import '/utils/as_t.dart';

class FileService {
  static const _fileUploadApi = '';

  static Future<String?> uploadFile({
    required File file,
    String path = '',
  }) async {
    final response = await post(
      _fileUploadApi,
      data: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(file.path),
      }),
    );
    return asT<String>(response.data!['dataInfo']['fileName']);
  }

  static Future<String?> uploadUnit8List({
    required Uint8List bytes,
    required String fileName,
    String path = '',
  }) async {
    final response = await post(
      _fileUploadApi,
      data: FormData.fromMap(<String, dynamic>{
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      }),
    );
    return asT<String>(response.data!['dataInfo']['fileName']);
  }
}
