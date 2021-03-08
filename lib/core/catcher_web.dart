import 'dart:async';
import 'dart:html';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CatcherWeb {
  static const String _channelName = "com.jhomlala/catcher/web";

  ///Register web method channel
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        _channelName, const StandardMethodCodec(), registrar.messenger);
    final CatcherWeb instance = CatcherWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  /// Handle method call
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "getUserAgent":
        return window.navigator.userAgent;
      case "getLanguage":
        return window.navigator.language;
      case "getVendor":
        return window.navigator.vendor;
      case "getPlatform":
        return window.navigator.platform;
      case "getCookieEnabled":
        return window.navigator.cookieEnabled;
    }
  }
}
