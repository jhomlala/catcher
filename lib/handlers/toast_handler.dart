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
  final String customMessage;

  ToastHandler(
      {this.gravity = ToastHandlerGravity.bottom,
      this.length = ToastHandlerLength.long,
      this.backgroundColor = Colors.black87,
      this.textColor = Colors.white,
      this.textSize = 12,
      this.customMessage})
      : assert(gravity != null, "gravity can't be null"),
        assert(length != null, "length can't be null"),
        assert(backgroundColor != null, "backgroundColor can't be null"),
        assert(textColor != null, "textColor can't be null"),
        assert(textSize != null, "textSize can't be null");

  @override
  Future<bool> handle(Report error) async {
    Fluttertoast.showToast(
        msg: _getErrorMessage(error),
        toastLength: _getLength(),
        gravity: _getGravity(),
        timeInSecForIosWeb: _getLengthIos(),
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: textSize);

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
    return ToastGravity.BOTTOM;
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
    if (customMessage != null && customMessage.length > 0) {
      return customMessage;
    } else {

      return "${localizationOptions.toastHandlerDescription} ${error.error}";
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}
