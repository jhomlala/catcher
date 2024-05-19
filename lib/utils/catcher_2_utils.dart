import 'package:catcher_2/core/application_profile_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_io/io.dart';

class Catcher2Utils {
  /// From https://stackoverflow.com/a/56959146/5894824
  static Future<bool> isInternetConnectionAvailable() async {
    if (ApplicationProfileManager.isWeb()) {
      return true; // TODO(HyperSpeeed): We could in theory handle this maybe?
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {}
    }
    return false;
  }

  static bool isCupertinoAppAncestor(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}

/// From https://stackoverflow.com/a/70282800/5894824
extension IsOk on Response {
  bool get ok => statusCode != null && (statusCode! ~/ 100) == 2;
}
