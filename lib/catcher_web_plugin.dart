import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the Catcher plugin.
class CatcherWebPlugin {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'catcher',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = CatcherWebPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: call.method,
        );
    }
  }
}
