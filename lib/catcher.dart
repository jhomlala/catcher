library catcher;

export "package:catcher/handlers/console_handler.dart";
export "package:catcher/handlers/email_handler.dart";
export "package:catcher/handlers/file_handler.dart";
export "package:catcher/handlers/http_handler.dart";
export "package:catcher/handlers/report_handler.dart";
export "package:catcher/handlers/toast_handler.dart";
export "package:catcher/mode/notification_report_mode.dart";
export 'package:catcher/mode/report_mode.dart';
export 'package:catcher/mode/silent_report_mode.dart';
export 'package:catcher/mode/report_mode_action_confirmed.dart';
export 'package:catcher/model/http_request_type.dart';
export 'package:catcher/model/report.dart';
export 'package:catcher/model/report_mode_type.dart';
export 'package:catcher/model/toast_handler_gravity.dart';
export 'package:catcher/model/toast_handler_length.dart';

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/mode/notification_report_mode.dart';
import 'package:catcher/mode/page_report_mode.dart';
import 'package:catcher/mode/report_mode.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_mode_type.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';

class Catcher with ReportModeAction {
  final List<ReportHandler> handlers;
  final Widget application;
  final int handlerTimeout;
  final ReportModeType reportModeType;
  final Map<String, dynamic> customParameters;

  ReportMode _reportMode;
  Map<String, dynamic> _deviceParameters = Map();
  Map<String, dynamic> _applicationParameters = Map();

  List<Report> _cachedReports = List();
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Catcher(this.application,
      {this.handlers = const [],
      this.handlerTimeout = 6000,
      this.reportModeType = ReportModeType.silent,
      this.customParameters = const {}}) {
    _setupReportMode();
    _loadDeviceInfo();
    _loadApplicationInfo();
    _setupErrorHooks(application);
  }

  void _setupReportMode() {
    if (this.reportModeType == ReportModeType.silent) {
      this._reportMode = SilentReportMode(this);
    } else if (this.reportModeType == ReportModeType.notification) {
      this._reportMode = NotificationReportMode(this);
    } else if (this.reportModeType == ReportModeType.page) {
      this._reportMode = PageReportMode(this);
    } else if (this.reportModeType == ReportModeType.dialog){
      this._reportMode = DialogReportMode(this);
    }
  }

  _setupErrorHooks(Widget application) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await _reportError(details.exception, details.stack);
    };

    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
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
    Report report = Report(error, stackTrace, DateTime.now(), _deviceParameters,
        _applicationParameters, customParameters);
    _cachedReports.add(report);

    if (_reportMode is PageReportMode || _reportMode is DialogReportMode) {
      if (_isContextValid()) {
        _reportMode.requestAction(report, _getContext());
      } else {
        print(
            "Couldn't use report mode becuase you didn't provide navigator key. Add navigator key to use this report mode.");
      }
    } else {
      _reportMode.requestAction(report, null);
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

  @override
  void onActionConfirmed() {
    List<Report> reportsToRemove = List();

    for (Report report in _cachedReports) {
      for (ReportHandler handler in handlers) {
        handler.handle(report).catchError((handlerError) {
          print(
              "Error occured in ${handler.toString()}: ${handlerError.toString()}");
        }).then((result) {
          if (!result) {
            print("${handler.toString()} failed to report error");
          } else {
            reportsToRemove.add(report);
          }
        }).timeout(Duration(milliseconds: handlerTimeout), onTimeout: () {
          print(
              "${handler.toString()} failed to report error because of timeout");
        });
      }
    }

    _cachedReports.removeWhere((report) => reportsToRemove.contains(report));
  }

  @override
  void onActionRejected() {
    print("On action rejected");
  }

  BuildContext _getContext() {
    return navigatorKey.currentState.overlay.context;
  }

  bool _isContextValid() {
    return navigatorKey.currentState != null;
  }
}
