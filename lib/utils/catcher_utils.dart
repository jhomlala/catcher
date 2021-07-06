import 'dart:io';

import 'package:flutter/cupertino.dart';

class CatcherUtils {
  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty == true && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (exception) {
      return Future.value(false);
    }
  }

  static bool isCupertinoAppAncestor(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
  }
}
