import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:catcher/utils/catcher_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///Manager which takes screenshot of configured widget. Screenshot will be saved
///to file which can be reused later.
class CatcherScreenshotManager {
  final CatcherLogger _logger;
  late GlobalKey _containerKey;
  String? _path;

  CatcherScreenshotManager(this._logger) {
    _containerKey = GlobalKey();
  }

  ///Unique global key used to create screenshot
  GlobalKey get containerKey => _containerKey;

  ///Create screenshot and save it in file. File will be created in directory
  ///specified in CatcherOptions.
  Future<File?> captureAndSave({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    try {
      if (_path?.isEmpty ?? false == true) {
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
    final name = 'catcher_${DateTime.now().microsecondsSinceEpoch}.png';
    final file = await File('$_path/$name').create(recursive: true);
    file.writeAsBytesSync(fileContent);
    return file;
  }

  Future<Uint8List?> _capture({
    double? pixelRatio,
    Duration delay = const Duration(milliseconds: 20),
  }) {
    //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
    return Future.delayed(delay, () async {
      try {
        final image = await captureAsUiImage(
          delay: Duration.zero,
          pixelRatio: pixelRatio,
        );
        final byteData =
            await image?.toByteData(format: ui.ImageByteFormat.png);
        image?.dispose();

        final pngBytes = byteData?.buffer.asUint8List();

        return pngBytes;
      } catch (exception) {
        _logger.severe('Failed to capture screenshot: $exception');
      }
      return null;
    });
  }

  Future<ui.Image?> captureAsUiImage({
    double? pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) {
    //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
    return Future.delayed(delay, () async {
      try {
        final findRenderObject =
            _containerKey.currentContext?.findRenderObject();

        print(containerKey.currentContext);
        print(_containerKey.currentContext?.findRenderObject());
        if (findRenderObject == null) {
          return null;
        }

        final boundary = findRenderObject as RenderRepaintBoundary;
        final context = _containerKey.currentContext;
        var pixelRatioValue = pixelRatio;
        if (pixelRatio == null) {
          if (context != null) {
            pixelRatioValue =
                pixelRatio ?? MediaQuery.of(context).devicePixelRatio;
          }
        }
        final image = await boundary.toImage(pixelRatio: pixelRatioValue ?? 1);
        return image;
      } catch (exception) {
        _logger.severe('Failed to capture screenshot: $exception');
      }
      return null;
    });
  }

  ///Update screenshots directory path.
  // ignore: avoid_setters_without_getters
  set path(String path) {
    _path = path;
  }
}
