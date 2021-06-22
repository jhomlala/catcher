import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logging/logging.dart';

class SnackbarHandler extends ReportHandler {
  final Logger _logger = Logger("SnackbarHandler");
  final String? customMessage;

  SnackbarHandler(this.customMessage);

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (!debugCheckHasScaffoldMessenger(context!)) {
      _logger
          .severe("Passed context has no ScaffoldMessenger in widget ancestor");
      return false;
    }

    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(_getErrorMessage(error)),
      duration: const Duration(seconds: 5),
    ));

    return true;
  }

  String _getErrorMessage(Report error) {
    if (customMessage?.isNotEmpty == true) {
      return customMessage!;
    } else {
      return "${localizationOptions.toastHandlerDescription} ${error.error}";
    }
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}
