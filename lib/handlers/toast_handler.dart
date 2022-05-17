import 'package:catcher/core/application_profile_manager.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/model/toast_handler_gravity.dart';
import 'package:catcher/model/toast_handler_length.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHandler extends ReportHandler {
  final ToastHandlerGravity gravity;
  final ToastHandlerLength length;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final String? customMessage;
  final bool handleWhenRejected;
  FToast? fToast;

  ToastHandler({
    this.gravity = ToastHandlerGravity.bottom,
    this.length = ToastHandlerLength.long,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.textSize = 12,
    this.customMessage,
    this.handleWhenRejected = false,
  });

  @override
  Future<bool> handle(Report error, BuildContext? buildContext) async {
    if (ApplicationProfileManager.isAndroid() ||
        ApplicationProfileManager.isIos() ||
        ApplicationProfileManager.isWeb()) {
      Fluttertoast.showToast(
        msg: _getErrorMessage(error),
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
            buildContext!,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => FlutterToastPage(
                _getErrorMessage(error),
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

  Toast _getLength() {
    if (length == ToastHandlerLength.long) {
      return Toast.LENGTH_LONG;
    } else {
      return Toast.LENGTH_SHORT;
    }
  }

  int _getLengthIos() {
    if (length == ToastHandlerLength.long) {
      return 5;
    } else {
      return 1;
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
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  bool shouldHandleWhenRejected() {
    return handleWhenRejected;
  }
}

class FlutterToastPage extends StatefulWidget {
  final String text;
  final ToastGravity gravity;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;

  const FlutterToastPage(
    this.text,
    this.gravity,
    this.duration,
    this.backgroundColor,
    this.textColor,
    this.textSize, {
    Key? key,
  }) : super(key: key);

  @override
  _FlutterToastPageState createState() => _FlutterToastPageState();
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
      child: Container(
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
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
