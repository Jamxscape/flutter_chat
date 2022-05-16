import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '/service/file_service.dart';
import 'easy_loading_utils.dart';
import 'log_utils.dart';

class FileUtils {
  static Future<Uint8List?> composeUnit8List(Uint8List bytes) async {
    return FlutterImageCompress.compressWithList(bytes);
  }

  static Future<File?> compose(File image) async {
    final Uint8List? value = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 50,
    );
    if (value == null) {
      return null;
    }
    String fileExt = '';
    try {
      fileExt = image.path.split('.').last;
    } catch (e) {
      print('$e');
    }
    var newPath = '${image.path}.tmp';
    if (fileExt.isNotEmpty) {
      newPath = image.path.replaceAll('.$fileExt', '.1.$fileExt');
    }
    final File file = File(newPath);
    //保存压缩后图片
    return file.writeAsBytes(value);
  }

  static Future<String?> composeUnit8ListAndUpload({
    required String fileName,
    String path = '',
    required Uint8List bytes,
  }) async {
    String? result;
    final Uint8List? composedBytes = await composeUnit8List(bytes);
    try {
      result = await FileService.uploadUnit8List(
        fileName: fileName,
        path: path,
        bytes: composedBytes!,
      );
    } catch (e, s) {
      error(e, showPath: false);
      error(s, showPath: false);
      showToast('图片上传失败，请稍后再试！');
    }

    return result;
  }

  static Future<String?> composeAndUpload({
    String path = '',
    required File file,
  }) async {
    final File? newImage = await compose(file);
    String? fileName;
    try {
      fileName = await FileService.uploadFile(path: path, file: newImage!);
    } catch (e, s) {
      error(e, showPath: false);
      error(s, showPath: false);
      showToast('图片上传失败，请稍后再试！');
    }
    try {
      newImage?.delete();
    } catch (e) {
      print(e);
    }
    return fileName;
  }
}
