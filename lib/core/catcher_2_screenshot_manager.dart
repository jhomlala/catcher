import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catcher_2/core/catcher_2_platform_interface.dart';
import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

/// Manager which takes screenshot of configured widget. Screenshot will be
/// saved to file which can be reused later.
class Catcher2ScreenshotManager {
  Catcher2ScreenshotManager(this._logger) : _containerKey = GlobalKey();
  final Catcher2Logger _logger;
  final GlobalKey _containerKey;
  String? _path;

  /// Unique global key used to create screenshot
  GlobalKey get containerKey => _containerKey;

  /// Create screenshot and save it in file. File will be created in directory
  /// specified in `Catcher2Options`.
  Future<XFile?> captureAndSave({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    try {
      final content = await _capture(pixelRatio: pixelRatio, delay: delay);

      if (content != null) {
        return await saveScreenshotFile(content);
      }
    } catch (exception) {
      _logger.warning('Failed to create screenshot file: $exception');
    }
    return null;
  }

  Future<XFile> saveScreenshotFile(Uint8List fileContent) async {
    final name = 'catcher_2_${DateTime.now().microsecondsSinceEpoch}.png';
    return Catcher2PlatformInterface.instance.saveFile(
      fileContent: fileContent,
      fileName: name,
      customPath: _path,
    );
  }

  Future<Uint8List?> _capture({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) =>
      //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
      Future.delayed(delay, () async {
        try {
          final image = await captureAsUiImage(
            delay: Duration.zero,
            pixelRatio: pixelRatio,
          );
          final byteData = await image?.toByteData(
            format: ui.ImageByteFormat.png,
          );
          image?.dispose();
          return byteData?.buffer.asUint8List();
        } catch (exception) {
          _logger.severe('Failed to capture screenshot: $exception');
        }
        return null;
      });

  Future<ui.Image?> captureAsUiImage({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) =>
      //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
      Future.delayed(delay, () async {
        try {
          final findRenderObject = _containerKey.currentContext
              ?.findRenderObject();

          if (findRenderObject == null) {
            return null;
          }

          final boundary = findRenderObject as RenderRepaintBoundary;
          final context = _containerKey.currentContext;
          var pixelRatioValue = pixelRatio;
          if (pixelRatioValue == null && context != null && context.mounted) {
            pixelRatioValue = MediaQuery.of(context).devicePixelRatio;
          }
          return await boundary.toImage(pixelRatio: pixelRatioValue ?? 1);
        } catch (exception) {
          _logger.severe('Failed to capture screenshot: $exception');
        }
        return null;
      });

  /// Update screenshots directory path.
  // ignore: avoid_setters_without_getters
  set path(String path) {
    _path = path;
  }
}
