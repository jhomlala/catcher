import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:catcher/core/application_profile_manager.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/mode/page_report_mode.dart';
import 'package:catcher/model/application_profile.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/localization_options.dart';
import 'package:catcher/model/report.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

class Catcher with ReportModeAction {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final Widget rootWidget;
  final CatcherOptions releaseConfig;
  final CatcherOptions debugConfig;
  final CatcherOptions profileConfig;

  final Logger _logger = Logger("Catcher");
  CatcherOptions _currentConfig;
  Map<String, dynamic> _deviceParameters = Map();
  Map<String, dynamic> _applicationParameters = Map();
  List<Report> _cachedReports = List();
  LocalizationOptions _localizationOptions;

  static Catcher _instance;

  Catcher(this.rootWidget,
      {this.releaseConfig, this.debugConfig, this.profileConfig}) {
    _configure();
  }

  _configure() {
    _instance = this;
    _configureLogger();
    _setupCurrentConfig();
    _setupErrorHooks();
    _setupLocalization();
    _setupReportMode();
    _loadDeviceInfo();
    _loadApplicationInfo();

    if (_currentConfig.handlers.isEmpty) {
      _logger
          .warning("Handlers list is empty. Configure at least one handler to "
              "process error reports.");
    } else {
      _logger.fine("Catcher configured successfully.");
    }
  }

  _setupCurrentConfig() {
    switch (ApplicationProfileManager.getApplicationProfile()) {
      case ApplicationProfile.release:
        {
          _logger.fine("Using release config");
          if (releaseConfig != null) {
            _currentConfig = releaseConfig;
          } else {
            _currentConfig = CatcherOptions.getDefaultReleaseOptions();
          }
          break;
        }
      case ApplicationProfile.debug:
        {
          _logger.fine("Using debug config");
          if (debugConfig != null) {
            _currentConfig = debugConfig;
          } else {
            _currentConfig = CatcherOptions.getDefaultDebugOptions();
          }
          break;
        }
      case ApplicationProfile.profile:
        {
          _logger.fine("Using profile config");
          if (profileConfig != null) {
            _currentConfig = profileConfig;
          } else {
            _currentConfig = CatcherOptions.getDefaultProfileOptions();
          }
          break;
        }
    }
  }

  void _setupReportMode() {
    this._currentConfig.reportMode.initialize(this, _localizationOptions);
  }

  _setupErrorHooks() {
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
      runApp(rootWidget);
    }, onError: (error, stackTrace) async {
      await _reportError(error, stackTrace);
    });
  }

  void _configureLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print(
          '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] ${rec.message}');
    });
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

  _setupLocalization() {
    BuildContext context = _getContext();
    Locale locale;
    if (context != null) {
      locale = Localizations.localeOf(context);
      _logger.info("Current locale: " + locale.languageCode);
    } else {
      locale = Locale("en", "US");
    }

    if (_currentConfig.localizationOptions != null) {
      for (var options in _currentConfig.localizationOptions) {
        if (options.languageCode.toLowerCase() ==
            locale.languageCode.toLowerCase()) {
          _localizationOptions = options;
        }
      }
    }

    if (_localizationOptions == null) {
      _localizationOptions = LocalizationOptions.buildDefault();
    }

    _logger
        .info("Using localization options: " + _localizationOptions.toString());
  }

  static reportCheckedError(dynamic error, dynamic stackTrace) {
    if (error == null) {
      error = "undefined error";
    }
    if (stackTrace == null) {
      stackTrace = StackTrace.current;
    }
    _instance._reportError(error, stackTrace);
  }

  _reportError(dynamic error, dynamic stackTrace) async {
    Report report = Report(error, stackTrace, DateTime.now(), _deviceParameters,
        _applicationParameters, _currentConfig.customParameters);
    _cachedReports.add(report);

    if (_currentConfig.reportMode is PageReportMode ||
        _currentConfig.reportMode is DialogReportMode) {
      if (_isContextValid()) {
        _currentConfig.reportMode.requestAction(report, _getContext());
      } else {
        _logger.warning(
            "Couldn't use report mode becuase you didn't provide navigator key. Add navigator key to use this report mode.");
      }
    } else {
      _currentConfig.reportMode.requestAction(report, null);
    }
  }

  @override
  void onActionConfirmed(Report report) {
    for (ReportHandler handler in _currentConfig.handlers) {
      handler.handle(report).catchError((handlerError) {
        _logger.warning(
            "Error occured in ${handler.toString()}: ${handlerError.toString()}");
      }).then((result) {
        print("Report result: " + result.toString());
        if (!result) {
          _logger.warning("${handler.toString()} failed to report error");
        } else {
          _cachedReports.remove(report);
        }
      }).timeout(Duration(milliseconds: _currentConfig.handlerTimeout),
          onTimeout: () {
        _logger.warning(
            "${handler.toString()} failed to report error because of timeout");
      });
    }
  }

  @override
  void onActionRejected(Report report) {
    _cachedReports.remove(report);
  }

  BuildContext _getContext() {
    return navigatorKey.currentState.overlay.context;
  }

  bool _isContextValid() {
    return navigatorKey.currentState != null;
  }
}
