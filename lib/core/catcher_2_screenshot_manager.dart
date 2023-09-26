library screenshot;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Manager which takes screenshot of configured widget. Screenshot will be
/// saved to file which can be reused later.
class Catcher2ScreenshotManager {
  final Catcher2Logger _logger;
  late GlobalKey _containerKey;
  String? _path;

  Catcher2ScreenshotManager(this._logger) {
    _containerKey = GlobalKey();
  }

  /// Unique global key used to create screenshot
  GlobalKey get containerKey => _containerKey;

  /// Create screenshot and save it in file. File will be created in directory
  /// specified in Catcher2Options.
  Future<File?> captureAndSave({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    try {
      if (_path?.isEmpty ?? false) {
        return null;
      }
      final content = await _capture(
        pixelRatio: pixelRatio,
        delay: delay,
      );

      if (content != null) {
        return saveFile(content);
      }
    } catch (exception) {
      _logger.warning('Failed to create screenshot file: $exception');
    }
    return null;
  }

  Future<File> saveFile(Uint8List fileContent) async {
    final name = 'catcher_2_${DateTime.now().microsecondsSinceEpoch}.png';
    final file = await File('$_path/$name').create(recursive: true);
    file.writeAsBytesSync(fileContent);
    return file;
  }

  Future<Uint8List?> _capture({
    double? pixelRatio,
    Duration? delay = const Duration(milliseconds: 20),
  }) =>
      Future.delayed(delay ?? const Duration(milliseconds: 20), () async {
        final image = await _captureAsUiImage(
          delay: Duration.zero,
          pixelRatio: pixelRatio,
        );
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();

        return pngBytes;
      });

  Future<ui.Image> _captureAsUiImage({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) =>
      Future.delayed(delay, () async {
        // ignore: cast_nullable_to_non_nullable
        final boundary = _containerKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary;

        // ignore: unnecessary_null_comparison
        if (boundary == null) {
          throw StateError('No boundary found');
        }

        final context = _containerKey.currentContext;
        var pixelRatioValue = pixelRatio;
        if (pixelRatioValue == null) {
          if (context != null) {
            pixelRatioValue =
                pixelRatioValue ?? MediaQuery.of(context).devicePixelRatio;
          }
        }
        final image = await boundary.toImage(pixelRatio: pixelRatio ?? 1);
        return image;
      });

  /// Update screenshots directory path.
  // ignore: avoid_setters_without_getters
  set path(String path) {
    _path = path;
  }
}
