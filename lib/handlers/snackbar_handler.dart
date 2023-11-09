import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';

///Handler which displays error report as snack bar.
class SnackbarHandler extends ReportHandler {
  ///See [SnackBar] docs for details.
  final Duration duration;

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
  final SnackBarBehavior? behavior;

  ///See [SnackBar] docs for details.
  final SnackBarAction? action;

  ///See [SnackBar] docs for details.
  final Animation<double>? animation;

  ///See [SnackBar] docs for details.
  final VoidCallback? onVisible;

  ///Custom message which can be displayed instead default one.
  final String? customMessage;

  ///Custom text style for text displayed within snackbar.
  final TextStyle? textStyle;

  ///Enable additional logs printing
  final bool printLogs;

  SnackbarHandler(
    this.duration, {
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.behavior,
    this.action,
    this.animation,
    this.onVisible,
    this.customMessage,
    this.textStyle,
    this.printLogs = false,
  });

  ///Handle report. If there's scaffold messenger in provided context, then
  ///snackbar will be shown.
  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    try {
      if (!_hasScaffoldMessenger(context!)) {
        _printLog('Passed context has no ScaffoldMessenger in widget ancestor');
        return false;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _getErrorMessage(error),
            style: textStyle,
          ),
          backgroundColor: backgroundColor,
          elevation: elevation,
          margin: margin,
          padding: padding,
          width: width,
          shape: shape,
          action: action,
          duration: duration,
          animation: animation,
          behavior: behavior,
          onVisible: onVisible,
        ),
      );
      return true;
    } catch (exception, stackTrace) {
      _printLog('Failed to show snackbar: $exception, $stackTrace');
      return false;
    }
  }

  ///Checks whether context has scaffold messenger.
  bool _hasScaffoldMessenger(BuildContext context) {
    try {
      return context.findAncestorWidgetOfExactType<ScaffoldMessenger>() != null;
    } catch (exception, stackTrace) {
      _printLog('_hasScaffoldMessenger failed: $exception, $stackTrace');
      return false;
    }
  }

  ///Get error message based on configuration and report.
  String _getErrorMessage(Report error) {
    if (customMessage?.isNotEmpty == true) {
      return customMessage!;
    } else {
      return '${localizationOptions.toastHandlerDescription} ${error.error}';
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
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
