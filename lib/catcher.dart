import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/report.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class Catcher {
  final List<ReportHandler> handlers;
  final Widget application;
  final int handlerTimeout;
  final Map<String, dynamic> customParameters;

  Map<String, dynamic> _deviceParameters = Map();
  Map<String, dynamic> _applicationParameters = Map();

  static Catcher _instance;

  Catcher(
      {@required this.application,
      this.handlers = const [],
      this.handlerTimeout = 5000,
      this.customParameters = const {} }) {
    _loadDeviceInfo();
    _loadApplicationInfo();
    _setupErrorHooks(application);
    _instance = this;
  }

  _setupErrorHooks(Widget application) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await _reportError(details.exception, details.stack);
    };

    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      print('Isolate.current.addErrorListener caught an error');
      print(pair);
      await _reportError(
        (pair as List<String>).first,
        (pair as List<String>).last,
      );
    }).sendPort);

    runZoned(() async {
      runApp(application);
    }, onError: (error, stackTrace) async {
      await _reportError(error, stackTrace);
    });
  }

  reportCheckedError(dynamic error, dynamic stackTrace) {
    _reportError(error, stackTrace);
  }

  _reportError(dynamic error, dynamic stackTrace) async {
    Report catcherError =
        Report(error, stackTrace, _deviceParameters, _applicationParameters, customParameters);
    for (ReportHandler handler in handlers) {
      handler.handle(catcherError).catchError((handlerError) {
        print(
            "Error occured in ${handler.toString()}: ${handlerError.toString()}");
      }).then((result) {
        if (!result) {
          print("${handler.toString()} failed to report error");
        }
      }).timeout(Duration(milliseconds: handlerTimeout), onTimeout: () {
        print(
            "${handler.toString()} failed to report error because of timeout");
      });
    }
  }

  _loadDeviceInfo() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((androidInfo) {
        _loadAndroidParameters(androidInfo);
      });
    } else {
      deviceInfo.iosInfo.then((iosInfo) {
        _loadiOSParameters(iosInfo);
      });
    }
  }

  void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    _deviceParameters["id"] = androidDeviceInfo.id;
    _deviceParameters["androidId"] = androidDeviceInfo.androidId;
    _deviceParameters["board"] = androidDeviceInfo.board;
    _deviceParameters["bootloader"] = androidDeviceInfo.bootloader;
    _deviceParameters["brand"] = androidDeviceInfo.brand;
    _deviceParameters["device"] = androidDeviceInfo.device;
    _deviceParameters["display"] = androidDeviceInfo.display;
    _deviceParameters["fingerprint"] = androidDeviceInfo.fingerprint;
    _deviceParameters["hardware"] = androidDeviceInfo.hardware;
    _deviceParameters["host"] = androidDeviceInfo.host;
    _deviceParameters["isPsychicalDevice"] = androidDeviceInfo.isPhysicalDevice;
    _deviceParameters["manufacturer"] = androidDeviceInfo.manufacturer;
    _deviceParameters["model"] = androidDeviceInfo.model;
    _deviceParameters["product"] = androidDeviceInfo.product;
    _deviceParameters["tags"] = androidDeviceInfo.tags;
    _deviceParameters["type"] = androidDeviceInfo.type;
    _deviceParameters["versionBaseOs"] = androidDeviceInfo.version.baseOS;
    _deviceParameters["versionCodename"] = androidDeviceInfo.version.codename;
    _deviceParameters["versionIncremental"] =
        androidDeviceInfo.version.incremental;
    _deviceParameters["versionPreviewSdk"] =
        androidDeviceInfo.version.previewSdkInt;
    _deviceParameters["versionRelase"] = androidDeviceInfo.version.release;
    _deviceParameters["versionSdk"] = androidDeviceInfo.version.sdkInt;
    _deviceParameters["versionSecurityPatch"] =
        androidDeviceInfo.version.securityPatch;
  }

  void _loadiOSParameters(IosDeviceInfo iosInfo) {
    _deviceParameters["model"] = iosInfo.model;
    _deviceParameters["isPsychicalDevice"] = iosInfo.isPhysicalDevice;
    _deviceParameters["name"] = iosInfo.name;
    _deviceParameters["identifierForVendor"] = iosInfo.identifierForVendor;
    _deviceParameters["localizedModel"] = iosInfo.localizedModel;
    _deviceParameters["systemName"] = iosInfo.systemName;
    _deviceParameters["utsnameVersion"] = iosInfo.utsname.version;
    _deviceParameters["utsnameRelease"] = iosInfo.utsname.release;
    _deviceParameters["utsnameMachine"] = iosInfo.utsname.machine;
    _deviceParameters["utsnameNodename"] = iosInfo.utsname.nodename;
    _deviceParameters["utsnameSysname"] = iosInfo.utsname.sysname;
  }

  void _loadApplicationInfo() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _applicationParameters["version"] = packageInfo.version;
      _applicationParameters["appName"] = packageInfo.appName;
      _applicationParameters["buildNumber"] = packageInfo.buildNumber;
      _applicationParameters["packageName"] = packageInfo.packageName;
    });
  }

  static Catcher getInstance() {
    if (_instance == null) {
      throw StateError("Instance not created");
    }
    return _instance;
  }
}
