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
import 'package:catcher/model/report_mode.dart';
import 'package:catcher/utils/catcher_error_widget.dart';
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
  bool enableLogger;

  static Catcher _instance;

  Catcher(
    this.rootWidget, {
    this.releaseConfig,
    this.debugConfig,
    this.profileConfig,
    this.enableLogger = true,
  }) {
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
    this
        ._currentConfig
        .explicitExceptionReportModesMap
        .forEach((error, reportMode) {
      reportMode.initialize(this, _localizationOptions);
    });
  }

  _setupErrorHooks() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      await _reportError(details.exception, details.stack);
    };

    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      var isolateError = pair as List<dynamic>;
      await _reportError(
        isolateError.first.toString(),
        isolateError.last.toString(),
      );
    }).sendPort);

    runZoned(() async {
      runApp(rootWidget);
    }, onError: (error, stackTrace) async {
      await _reportError(error, stackTrace);
    });
  }

  void _configureLogger() {
    if (enableLogger) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print(
            '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] ${rec.message}');
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
        _loadIosParameters(iosInfo);
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

  void _loadIosParameters(IosDeviceInfo iosInfo) {
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
      _applicationParameters["environment"] = ApplicationProfileManager.getApplicationProfile().toString();
    });
  }

  _setupLocalization() {
    Locale locale = Locale("en", "US");
    if (_isContextValid()) {
      BuildContext context = _getContext();
      if (context != null) {
        locale = Localizations.localeOf(context);
      }

      if (_currentConfig.localizationOptions != null) {
        for (var options in _currentConfig.localizationOptions) {
          if (options.languageCode.toLowerCase() ==
              locale.languageCode.toLowerCase()) {
            _localizationOptions = options;
          }
        }
      }
    }

    if (_localizationOptions == null) {
      _localizationOptions =
          _getDefaultLocalizationOptionsForLanguage(locale.languageCode);
    }
  }

  LocalizationOptions _getDefaultLocalizationOptionsForLanguage(
      String language) {
    switch (language.toLowerCase()) {
      case "en":
        return LocalizationOptions.buildDefaultEnglishOptions();
      case "zh":
        return LocalizationOptions.buildDefaultChineseOptions();
      case "hi":
        return LocalizationOptions.buildDefaultHindiOptions();
      case "es":
        return LocalizationOptions.buildDefaultSpanishOptions();
      case "ms":
        return LocalizationOptions.buildDefaultMalayOptions();
      case "ru":
        return LocalizationOptions.buildDefaultRussianOptions();
      case "pt":
        return LocalizationOptions.buildDefaultPortugueseOptions();
      case "fr":
        return LocalizationOptions.buildDefaultFrenchOptions();
      case "pl":
        return LocalizationOptions.buildDefaultPolishOptions();
      case "it":
        return LocalizationOptions.buildDefaultItalianOptions();
      default:
        return LocalizationOptions.buildDefaultEnglishOptions();
    }
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
    ReportMode reportMode =
        _getReportModeFromExplicitExceptionReportModeMap(error);
    if (reportMode != null) {
      _logger.info("Using explicit report mode for error");
    } else {
      reportMode = _currentConfig.reportMode;
    }

    if (reportMode is PageReportMode || reportMode is DialogReportMode) {
      if (_isContextValid()) {
        reportMode.requestAction(report, _getContext());
      } else {
        _logger.warning(
            "Couldn't use report mode becuase you didn't provide navigator key. Add navigator key to use this report mode.");
      }
    } else {
      reportMode.requestAction(report, null);
    }
  }

  ReportMode _getReportModeFromExplicitExceptionReportModeMap(dynamic error) {
    var errorName = error != null ? error.toString().toLowerCase() : "";
    ReportMode reportMode;
    _currentConfig.explicitExceptionReportModesMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportMode = value;
        return;
      }
    });
    return reportMode;
  }

  ReportHandler _getReportHandlerFromExplicitExceptionHandlerMap(
      dynamic error) {
    var errorName = error != null ? error.toString().toLowerCase() : "";
    ReportHandler reportHandler;
    _currentConfig.explicitExceptionHandlersMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportHandler = value;
        return;
      }
    });
    return reportHandler;
  }

  @override
  void onActionConfirmed(Report report) {
    ReportHandler reportHandler =
        _getReportHandlerFromExplicitExceptionHandlerMap(report.error);
    if (reportHandler != null) {
      _logger.info("Using explicit report handler");
      reportHandler.handle(report);
      return;
    }

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
    return navigatorKey.currentState != null &&
        navigatorKey.currentState.overlay != null;
  }

  static void sendTestException() {
    throw FormatException("Test");
  }

  static void addDefaultErrorWidget(
      {bool showStacktrace, String customTitle, String customDescription}) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return CatcherErrorWidget(
        details: details,
        showStacktrace: showStacktrace,
        customTitle: customTitle,
        customDescription: customDescription,
      );
    };
  }
}
