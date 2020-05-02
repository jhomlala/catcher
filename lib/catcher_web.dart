import 'dart:async';
import 'dart:html';

import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CatcherWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel('jhomlala/catcherweb',
        const StandardMethodCodec(), registrar.messenger);
    final CatcherWeb instance = CatcherWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
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
