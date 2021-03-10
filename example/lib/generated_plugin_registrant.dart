//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

import 'package:device_info_plus_web/device_info_plus_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  DeviceInfoPlusPlugin.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
