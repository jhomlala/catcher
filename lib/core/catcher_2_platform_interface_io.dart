import 'dart:typed_data';

import 'package:catcher_2/core/catcher_2_platform_interface.dart';
import 'package:cross_file/cross_file.dart';

class Catcher2PlatformInterfaceIO extends Catcher2PlatformInterface {
  @override
  Future<XFile> saveFile({
    required Uint8List fileContent,
    required String fileName,
    String? customPath,
  }) async {
    final path = (customPath?.isEmpty ?? true)
        ? fileName
        : '$customPath/$fileName';
    final file = FileSystemXFile(path);
    await file.writeAsBytes(fileContent);
    return file;
  }
}

Catcher2PlatformInterface createCatcher2PlatformInterface() =>
    Catcher2PlatformInterfaceIO();
