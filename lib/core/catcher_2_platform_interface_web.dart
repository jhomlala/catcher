import 'dart:js_interop';
import 'dart:typed_data';

import 'package:catcher_2/core/catcher_2_platform_interface.dart';
import 'package:cross_file/cross_file.dart';
import 'package:cross_file_web/cross_file_web.dart';
import 'package:web/web.dart' as web;

class Catcher2PlatformInterfaceWeb extends Catcher2PlatformInterface {
  @override
  Future<XFile> saveFile({
    required Uint8List fileContent,
    required String fileName,
    String? customPath,
  }) async {
    final webFile = web.File([fileContent.toJS].toJS, fileName);
    return ScopedStorageXFile.fromCreationParams(
      WebScopedStorageXFileCreationParams.fromBlob(webFile),
    );
  }
}

Catcher2PlatformInterface createCatcher2PlatformInterface() =>
    Catcher2PlatformInterfaceWeb();
