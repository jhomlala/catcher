import 'package:catcher/model/report.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHandler extends ReportHandler {
  final ToastHandlerGravity gravity;
  final ToastHandlerLength length;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final String customMessage;

  const ToastHandler(
      {this.gravity = ToastHandlerGravity.bottom,
      this.length = ToastHandlerLength.long,
      this.backgroundColor = Colors.black87,
      this.textColor = Colors.white,
      this.fontSize = 12,
      this.customMessage});

  @override
  Future<bool> handle(Report error) {
    Fluttertoast.showToast(
        msg: _getErrorMessage(error),
        toastLength: _getLength(),
        gravity: _getGravity(),
        timeInSecForIos: _getLengthIos(),
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);

    return SynchronousFuture(true);
  }

  ToastGravity _getGravity() {
    switch(gravity){
      case ToastHandlerGravity.bottom: return ToastGravity.BOTTOM;
      case ToastHandlerGravity.center: return ToastGravity.CENTER;
      case ToastHandlerGravity.top: return ToastGravity.TOP;
    }
    return ToastGravity.TOP;
  }

  Toast _getLength(){
    if (length == ToastHandlerLength.long){
      return Toast.LENGTH_LONG;
    } else {
      return Toast.LENGTH_SHORT;
    }
  }

  int _getLengthIos(){
    if (length == ToastHandlerLength.long){
      return 5;
    } else {
      return 1;
    }
  }

  String _getErrorMessage(Report error){
    if (customMessage != null && customMessage.length > 0){
      return customMessage;
    } else {
      return "Error occured: ${error.error}";
    }
  }


}

enum ToastHandlerLength { short, long }

enum ToastHandlerGravity { bottom, center, top }
