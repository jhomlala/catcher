import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logging/logging.dart';

///Handler which displays error report as snack bar.
class SnackbarHandler extends ReportHandler {
  final Logger _logger = Logger("SnackbarHandler");

  ///See [SnackBar] docs for details.
  final Color? backgroundColor;

  ///See [SnackBar] docs for details.
  final double? elevation;

  ///See [SnackBar] docs for details.
  final EdgeInsetsGeometry? margin;

  ///See [SnackBar] docs for details.
  final EdgeInsetsGeometry? padding;

  ///See [SnackBar] docs for details.
  final double? width;

  ///See [SnackBar] docs for details.
  final ShapeBorder? shape;

  ///See [SnackBar] docs for details.
  final SnackBarAction? action;

  ///See [SnackBar] docs for details.
  final Duration duration;

  ///See [SnackBar] docs for details.
  final Animation<double>? animation;

  ///See [SnackBar] docs for details.
  final VoidCallback? onVisible;

  ///Custom message which can be displayed instead default one.
  final String? customMessage;

  SnackbarHandler(
    this.duration, {
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.action,
    this.animation,
    this.onVisible,
    this.customMessage,
  });

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (!_hasScaffoldMessenger(context!)) {
      _logger
          .severe("Passed context has no ScaffoldMessenger in widget ancestor");
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_getErrorMessage(error)),
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      action: action,
      duration: duration,
      animation: animation,
      onVisible: onVisible,
    ));

    return true;
  }

  bool _hasScaffoldMessenger(BuildContext context) {
    try {
      return context.findAncestorWidgetOfExactType<ScaffoldMessenger>() != null;
    } catch (exception, stackTrace) {
      _logger.severe("_hasScaffoldMessenger failed", exception, stackTrace);
      return false;
    }
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
