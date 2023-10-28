import 'dart:io';

import 'package:flutter/cupertino.dart';

class Catcher2Utils {
  /// From https://stackoverflow.com/a/56959146/5894824
  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (exception) {
      return false;
    }
  }

  static bool isCupertinoAppAncestor(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}
