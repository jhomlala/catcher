import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';

import 'catcher_2_platform_interface_stub.dart'
    if (dart.library.io) 'catcher_2_platform_interface_io.dart'
    if (dart.library.js_interop) 'catcher_2_platform_interface_web.dart';

abstract class Catcher2PlatformInterface {
  static final Catcher2PlatformInterface instance =
      createCatcher2PlatformInterface();

  Future<XFile> saveFile({
    required Uint8List fileContent,
    required String fileName,
    String? customPath,
  });
}
