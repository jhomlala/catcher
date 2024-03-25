import 'package:catcher_2/core/application_profile_manager.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/model/toast_handler_gravity.dart';
import 'package:catcher_2/model/toast_handler_length.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHandler extends ReportHandler {
  ToastHandler({
    this.gravity = ToastHandlerGravity.bottom,
    this.length = ToastHandlerLength.long,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.textSize = 12,
    this.customMessage,
    this.handleWhenRejected = false,
  });

  final ToastHandlerGravity gravity;
  final ToastHandlerLength length;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final String? customMessage;
  final bool handleWhenRejected;

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    if (ApplicationProfileManager.isAndroid() ||
        ApplicationProfileManager.isIos() ||
        ApplicationProfileManager.isWeb()) {
      await Fluttertoast.showToast(
        msg: _getErrorMessage(report),
        toastLength: _getLength(),
        gravity: _getGravity(),
        timeInSecForIosWeb: _getLengthIos(),
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: textSize,
      );
    } else {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          Navigator.push<void>(
            context!,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => FlutterToastPage(
                _getErrorMessage(report),
                _getGravity(),
                Duration(seconds: _getLengthIos()),
                backgroundColor,
                textColor,
                textSize,
              ),
            ),
          );
        },
      );
    }

    return true;
  }

  ToastGravity _getGravity() {
    switch (gravity) {
      case ToastHandlerGravity.bottom:
        return ToastGravity.BOTTOM;
      case ToastHandlerGravity.center:
        return ToastGravity.CENTER;
      case ToastHandlerGravity.top:
        return ToastGravity.TOP;
    }
  }

  Toast _getLength() => length == ToastHandlerLength.long
      ? Toast.LENGTH_LONG
      : Toast.LENGTH_SHORT;

  int _getLengthIos() => length == ToastHandlerLength.long ? 5 : 1;

  String _getErrorMessage(Report error) => customMessage?.isNotEmpty ?? false
      ? customMessage!
      : '${localizationOptions.toastHandlerDescription} ${error.error}';

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  bool isContextRequired() => true;

  @override
  bool shouldHandleWhenRejected() => handleWhenRejected;
}

class FlutterToastPage extends StatefulWidget {
  const FlutterToastPage(
    this.text,
    this.gravity,
    this.duration,
    this.backgroundColor,
    this.textColor,
    this.textSize, {
    super.key,
  });

  final String text;
  final ToastGravity gravity;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;

  @override
  State<FlutterToastPage> createState() => _FlutterToastPageState();
}

class _FlutterToastPageState extends State<FlutterToastPage> {
  final FToast _fToast = FToast();
  bool _disposed = false;

  @override
  void initState() {
    _fToast.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed && mounted) {
        showToast();
      }
    });
    super.initState();
  }

  void showToast() {
    _fToast.showToast(
      child: ColoredBox(
        color: widget.backgroundColor,
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.textSize,
          ),
        ),
      ),
      gravity: widget.gravity,
      toastDuration: widget.duration,
    );
    Future.delayed(
      Duration(milliseconds: widget.duration.inMilliseconds + 100),
      () {
        if (!_disposed && mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
