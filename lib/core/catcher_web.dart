import 'dart:async';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CatcherWeb {
  static const String _channelName = "com.jhomlala/catcher/web";

  ///Register web method channel
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(_channelName,
        const StandardMethodCodec(), registrar as BinaryMessenger);
    final CatcherWeb instance = CatcherWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  /// Handle method call
  Future<dynamic> handleMethodCall(MethodCall call) async {
    assert(call != null, "Call can't be null!");
    switch (call.method) {
      case "getUserAgent":
        return window.navigator.userAgent;
        break;
      case "getLanguage":
        return window.navigator.language;
        break;
      case "getVendor":
        return window.navigator.vendor;
        break;
      case "getPlatform":
        return window.navigator.platform;
        break;
      case "getCookieEnabled":
        return window.navigator.cookieEnabled;
        break;
    }
  }
}
