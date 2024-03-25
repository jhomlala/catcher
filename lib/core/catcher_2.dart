import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:catcher_2/core/application_profile_manager.dart';
import 'package:catcher_2/core/catcher_2_screenshot_manager.dart';
import 'package:catcher_2/mode/report_mode_action_confirmed.dart';
import 'package:catcher_2/model/application_profile.dart';
import 'package:catcher_2/model/catcher_2_options.dart';
import 'package:catcher_2/model/localization_options.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/model/report_mode.dart';
import 'package:catcher_2/utils/catcher_2_error_widget.dart';
import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Catcher2 implements ReportModeAction {
  /// Builds catcher 2 instance
  Catcher2({
    this.rootWidget,
    this.runAppFunction,
    this.releaseConfig,
    this.debugConfig,
    this.profileConfig,
    this.enableLogger = true,
    this.ensureInitialized = false,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : assert(
          rootWidget != null || runAppFunction != null,
          'You need to provide rootWidget or runAppFunction',
        ) {
    _configure(navigatorKey);
  }

  static late Catcher2 _instance;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Root widget that is run using [runApp], see also [runAppFunction] if you
  /// want to customise how the widget is run
  final Widget? rootWidget;

  /// The function to be executed after setup, should at least call [runApp].
  /// See also [rootWidget] if no special configuration is necessary and only a
  /// call to [runApp] is enough.
  final void Function()? runAppFunction;

  /// Instance of catcher 2 config used in release mode
  Catcher2Options? releaseConfig;

  /// Instance of catcher 2 config used in debug mode
  Catcher2Options? debugConfig;

  /// Instance of catcher 2 config used in profile mode
  Catcher2Options? profileConfig;

  /// Should catcher 2 logs be enabled
  final bool enableLogger;

  /// Should catcher 2 run WidgetsFlutterBinding.ensureInitialized() during
  /// initialization.
  final bool ensureInitialized;

  late Catcher2Options _currentConfig;
  late Catcher2Logger _logger;
  late Catcher2ScreenshotManager screenshotManager;
  final Map<String, dynamic> _deviceParameters = <String, dynamic>{};
  final Map<String, dynamic> _applicationParameters = <String, dynamic>{};
  final List<Report> _cachedReports = [];
  final Map<DateTime, String> _reportsOccurrenceMap = {};
  LocalizationOptions? _localizationOptions;

  /// Instance of navigator key
  static GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  void _configure(GlobalKey<NavigatorState>? navigatorKey) {
    _instance = this;
    _initWidgetsBinding();
    _configureNavigatorKey(navigatorKey);
    _setupCurrentConfig();
    _configureLogger();
    _setupReportModeActionInReportMode();
    _setupScreenshotManager();

    _loadDeviceInfo();
    _loadApplicationInfo();

    _setupErrorHooks();

    if (_currentConfig.handlers.isEmpty) {
      _logger.warning(
        'Handlers list is empty. Configure at least one handler to '
        'process error reports.',
      );
    } else {
      _logger.fine('Catcher 2 configured successfully.');
    }
  }

  void _configureNavigatorKey(GlobalKey<NavigatorState>? navigatorKey) {
    if (navigatorKey != null) {
      _navigatorKey = navigatorKey;
    } else {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }

  void _setupCurrentConfig() {
    switch (ApplicationProfileManager.getApplicationProfile()) {
      case ApplicationProfile.release:
        _currentConfig =
            releaseConfig ?? Catcher2Options.getDefaultReleaseOptions();
      case ApplicationProfile.debug:
        _currentConfig =
            debugConfig ?? Catcher2Options.getDefaultDebugOptions();
      case ApplicationProfile.profile:
        _currentConfig =
            profileConfig ?? Catcher2Options.getDefaultProfileOptions();
    }
  }

  /// Update config after initialization
  void updateConfig({
    Catcher2Options? debugConfig,
    Catcher2Options? profileConfig,
    Catcher2Options? releaseConfig,
  }) {
    if (debugConfig != null) {
      this.debugConfig = debugConfig;
    }
    if (profileConfig != null) {
      this.profileConfig = profileConfig;
    }
    if (releaseConfig != null) {
      this.releaseConfig = releaseConfig;
    }
    _setupCurrentConfig();
    _configureLogger();
    _setupReportModeActionInReportMode();
    _setupScreenshotManager();
    _localizationOptions = null;
  }

  void _setupReportModeActionInReportMode() {
    _currentConfig.reportMode.reportModeAction = this;
    _currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.reportModeAction = this;
      },
    );
  }

  void _setupLocalizationsOptionsInReportMode() {
    _currentConfig.reportMode.localizationOptions = _localizationOptions;
    _currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.localizationOptions = _localizationOptions;
      },
    );
  }

  void _setupLocalizationsOptionsInReportsHandler() {
    for (final handler in _currentConfig.handlers) {
      handler.localizationOptions = _localizationOptions;
    }
  }

  Future<void> _setupErrorHooks() async {
    FlutterError.onError = (details) async {
      await _reportError(
        details.exception,
        details.stack,
        errorDetails: details,
      );
      _currentConfig.onFlutterError?.call(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _reportError(error, stack);
      _currentConfig.onPlatformError?.call(error, stack);
      return true;
    };

    /// Web doesn't have Isolate error listener support
    if (!ApplicationProfileManager.isWeb()) {
      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final isolateError = pair as List<dynamic>;
          await _reportError(
            isolateError.first.toString(),
            isolateError.last.toString(),
          );
        }).sendPort,
      );
    }

    if (rootWidget != null) {
      runApp(rootWidget!);
    } else if (runAppFunction != null) {
      runAppFunction!();
    } else {
      throw ArgumentError('Provide rootWidget or runAppFunction to Catcher 2.');
    }
  }

  void _initWidgetsBinding() {
    if (ensureInitialized) {
      WidgetsFlutterBinding.ensureInitialized();
    }
  }

  void _configureLogger() {
    _logger = _currentConfig.logger ?? Catcher2Logger();
    if (enableLogger) {
      _logger.setup();
    }

    for (final handler in _currentConfig.handlers) {
      handler.logger = _logger;
    }
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (ApplicationProfileManager.isWeb()) {
        final webBrowserInfo = await deviceInfo.webBrowserInfo;
        _loadWebParameters(webBrowserInfo);
      } else if (ApplicationProfileManager.isLinux()) {
        final linuxDeviceInfo = await deviceInfo.linuxInfo;
        _loadLinuxParameters(linuxDeviceInfo);
      } else if (ApplicationProfileManager.isWindows()) {
        final windowsInfo = await deviceInfo.windowsInfo;
        _loadWindowsParameters(windowsInfo);
      } else if (ApplicationProfileManager.isMacOS()) {
        final macOsDeviceInfo = await deviceInfo.macOsInfo;
        _loadMacOSParameters(macOsDeviceInfo);
      } else if (ApplicationProfileManager.isAndroid()) {
        final androidInfo = await deviceInfo.androidInfo;
        _loadAndroidParameters(androidInfo);
      } else if (ApplicationProfileManager.isIos()) {
        final iosInfo = await deviceInfo.iosInfo;
        _loadIosParameters(iosInfo);
      } else {
        _logger.info("Couldn't load device info for unsupported device type.");
      }
      _removeExcludedParameters();
    } catch (exception) {
      _logger.warning("Couldn't load device info due to error: $exception");
    }
  }

  /// Remove excluded parameters from device parameters.
  void _removeExcludedParameters() =>
      _currentConfig.excludedParameters.forEach(_deviceParameters.remove);

  void _loadLinuxParameters(LinuxDeviceInfo linuxDeviceInfo) {
    try {
      _deviceParameters['name'] = linuxDeviceInfo.name;
      _deviceParameters['version'] = linuxDeviceInfo.version;
      _deviceParameters['id'] = linuxDeviceInfo.id;
      _deviceParameters['idLike'] = linuxDeviceInfo.idLike;
      _deviceParameters['versionCodename'] = linuxDeviceInfo.versionCodename;
      _deviceParameters['versionId'] = linuxDeviceInfo.versionId;
      _deviceParameters['prettyName'] = linuxDeviceInfo.prettyName;
      _deviceParameters['buildId'] = linuxDeviceInfo.buildId;
      _deviceParameters['variant'] = linuxDeviceInfo.variant;
      _deviceParameters['variantId'] = linuxDeviceInfo.variantId;
      _deviceParameters['machineId'] = linuxDeviceInfo.machineId;
    } catch (exception) {
      _logger.warning('Load Linux parameters failed: $exception');
    }
  }

  void _loadMacOSParameters(MacOsDeviceInfo macOsDeviceInfo) {
    try {
      _deviceParameters['computerName'] = macOsDeviceInfo.computerName;
      _deviceParameters['hostName'] = macOsDeviceInfo.hostName;
      _deviceParameters['arch'] = macOsDeviceInfo.arch;
      _deviceParameters['model'] = macOsDeviceInfo.model;
      _deviceParameters['kernelVersion'] = macOsDeviceInfo.kernelVersion;
      _deviceParameters['osRelease'] = macOsDeviceInfo.osRelease;
      _deviceParameters['activeCPUs'] = macOsDeviceInfo.activeCPUs;
      _deviceParameters['memorySize'] = macOsDeviceInfo.memorySize;
      _deviceParameters['cpuFrequency'] = macOsDeviceInfo.cpuFrequency;
    } catch (exception) {
      _logger.warning('Load MacOS parameters failed: $exception');
    }
  }

  void _loadWindowsParameters(WindowsDeviceInfo windowsDeviceInfo) {
    try {
      _deviceParameters['computerName'] = windowsDeviceInfo.computerName;
      _deviceParameters['numberOfCores'] = windowsDeviceInfo.numberOfCores;
      _deviceParameters['systemMemoryInMegabytes'] =
          windowsDeviceInfo.systemMemoryInMegabytes;
    } catch (exception) {
      _logger.warning('Load Windows parameters failed: $exception');
    }
  }

  void _loadWebParameters(WebBrowserInfo webBrowserInfo) {
    try {
      _deviceParameters['language'] = webBrowserInfo.language;
      _deviceParameters['appCodeName'] = webBrowserInfo.appCodeName;
      _deviceParameters['appName'] = webBrowserInfo.appName;
      _deviceParameters['appVersion'] = webBrowserInfo.appVersion;
      _deviceParameters['browserName'] = webBrowserInfo.browserName.toString();
      _deviceParameters['deviceMemory'] = webBrowserInfo.deviceMemory;
      _deviceParameters['hardwareConcurrency'] =
          webBrowserInfo.hardwareConcurrency;
      _deviceParameters['languages'] = webBrowserInfo.languages;
      _deviceParameters['maxTouchPoints'] = webBrowserInfo.maxTouchPoints;
      _deviceParameters['platform'] = webBrowserInfo.platform;
      _deviceParameters['product'] = webBrowserInfo.product;
      _deviceParameters['productSub'] = webBrowserInfo.productSub;
      _deviceParameters['userAgent'] = webBrowserInfo.userAgent;
      _deviceParameters['vendor'] = webBrowserInfo.vendor;
      _deviceParameters['vendorSub'] = webBrowserInfo.vendorSub;
    } catch (exception) {
      _logger.warning('Load Web parameters failed: $exception');
    }
  }

  void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    try {
      _deviceParameters['id'] = androidDeviceInfo.id;
      // TODO(N): _deviceParameters["androidId"] = androidDeviceInfo.androidId;
      _deviceParameters['board'] = androidDeviceInfo.board;
      _deviceParameters['bootloader'] = androidDeviceInfo.bootloader;
      _deviceParameters['brand'] = androidDeviceInfo.brand;
      _deviceParameters['device'] = androidDeviceInfo.device;
      _deviceParameters['display'] = androidDeviceInfo.display;
      _deviceParameters['fingerprint'] = androidDeviceInfo.fingerprint;
      _deviceParameters['hardware'] = androidDeviceInfo.hardware;
      _deviceParameters['host'] = androidDeviceInfo.host;
      _deviceParameters['isPhysicalDevice'] =
          androidDeviceInfo.isPhysicalDevice;
      _deviceParameters['manufacturer'] = androidDeviceInfo.manufacturer;
      _deviceParameters['model'] = androidDeviceInfo.model;
      _deviceParameters['product'] = androidDeviceInfo.product;
      _deviceParameters['tags'] = androidDeviceInfo.tags;
      _deviceParameters['type'] = androidDeviceInfo.type;
      _deviceParameters['versionBaseOs'] = androidDeviceInfo.version.baseOS;
      _deviceParameters['versionCodename'] = androidDeviceInfo.version.codename;
      _deviceParameters['versionIncremental'] =
          androidDeviceInfo.version.incremental;
      _deviceParameters['versionPreviewSdk'] =
          androidDeviceInfo.version.previewSdkInt;
      _deviceParameters['versionRelease'] = androidDeviceInfo.version.release;
      _deviceParameters['versionSdk'] = androidDeviceInfo.version.sdkInt;
      _deviceParameters['versionSecurityPatch'] =
          androidDeviceInfo.version.securityPatch;
    } catch (exception) {
      _logger.warning('Load Android parameters failed: $exception');
    }
  }

  void _loadIosParameters(IosDeviceInfo iosInfo) {
    try {
      _deviceParameters['model'] = iosInfo.model;
      _deviceParameters['isPhysicalDevice'] = iosInfo.isPhysicalDevice;
      _deviceParameters['name'] = iosInfo.name;
      _deviceParameters['identifierForVendor'] = iosInfo.identifierForVendor;
      _deviceParameters['localizedModel'] = iosInfo.localizedModel;
      _deviceParameters['systemName'] = iosInfo.systemName;
      _deviceParameters['utsnameVersion'] = iosInfo.utsname.version;
      _deviceParameters['utsnameRelease'] = iosInfo.utsname.release;
      _deviceParameters['utsnameMachine'] = iosInfo.utsname.machine;
      _deviceParameters['utsnameNodename'] = iosInfo.utsname.nodename;
      _deviceParameters['utsnameSysname'] = iosInfo.utsname.sysname;
    } catch (exception) {
      _logger.warning('Load iOS parameters failed: $exception');
    }
  }

  Future<void> _loadApplicationInfo() async {
    try {
      _applicationParameters['environment'] =
          ApplicationProfileManager.getApplicationProfile().name;

      final packageInfo = await PackageInfo.fromPlatform();
      _applicationParameters['version'] = packageInfo.version;
      _applicationParameters['appName'] = packageInfo.appName;
      _applicationParameters['buildNumber'] = packageInfo.buildNumber;
      _applicationParameters['packageName'] = packageInfo.packageName;
    } catch (exception) {
      _logger
          .warning("Couldn't load application info due to error: $exception");
    }
  }

  /// We need to setup localizations lazily because context needed to setup
  /// these localizations can be used after app was build for the first time.
  void _setupLocalization() {
    var locale = const Locale('en', 'US');
    if (_isContextValid()) {
      final context = _getContext();
      if (context != null) {
        locale = Localizations.localeOf(context);
      }
      if (_currentConfig.localizationOptions.isNotEmpty) {
        for (final options in _currentConfig.localizationOptions) {
          if (options.languageCode.toLowerCase() ==
              locale.languageCode.toLowerCase()) {
            _localizationOptions = options;
          }
        }
      }
    }

    _localizationOptions ??=
        _getDefaultLocalizationOptionsForLanguage(locale.languageCode);
    _setupLocalizationsOptionsInReportMode();
    _setupLocalizationsOptionsInReportsHandler();
  }

  LocalizationOptions _getDefaultLocalizationOptionsForLanguage(
    String language,
  ) {
    switch (language.toLowerCase()) {
      case 'ar':
        return LocalizationOptions.buildDefaultArabicOptions();
      case 'zh':
        return LocalizationOptions.buildDefaultChineseOptions();
      case 'hi':
        return LocalizationOptions.buildDefaultHindiOptions();
      case 'es':
        return LocalizationOptions.buildDefaultSpanishOptions();
      case 'ms':
        return LocalizationOptions.buildDefaultMalayOptions();
      case 'ru':
        return LocalizationOptions.buildDefaultRussianOptions();
      case 'pt':
        return LocalizationOptions.buildDefaultPortugueseOptions();
      case 'fr':
        return LocalizationOptions.buildDefaultFrenchOptions();
      case 'pl':
        return LocalizationOptions.buildDefaultPolishOptions();
      case 'it':
        return LocalizationOptions.buildDefaultItalianOptions();
      case 'ko':
        return LocalizationOptions.buildDefaultKoreanOptions();
      case 'nl':
        return LocalizationOptions.buildDefaultDutchOptions();
      case 'de':
        return LocalizationOptions.buildDefaultGermanOptions();
      case 'tr':
        return LocalizationOptions.buildDefaultTurkishOptions();
      default: // Also covers 'en'
        return LocalizationOptions.buildDefaultEnglishOptions();
    }
  }

  /// Setup screenshot manager's screenshots path.
  void _setupScreenshotManager() {
    screenshotManager = Catcher2ScreenshotManager(_logger);
    final screenshotsPath = _currentConfig.screenshotsPath;
    if (!ApplicationProfileManager.isWeb() && screenshotsPath.isEmpty) {
      _logger.warning("Screenshots path is empty. Screenshots won't work.");
    }
    screenshotManager.path = screenshotsPath;
  }

  /// Report checked error (error caught in try-catch block). Catcher 2 will
  /// treat this as normal exception and pass it to handlers.
  static void reportCheckedError(error, stackTrace) {
    dynamic errorValue = error;
    dynamic stackTraceValue = stackTrace;
    errorValue ??= 'undefined error';
    stackTraceValue ??= StackTrace.current;
    _instance._reportError(error, stackTrace);
  }

  Future<void> _reportError(
    error,
    stackTrace, {
    FlutterErrorDetails? errorDetails,
  }) async {
    if ((errorDetails?.silent ?? false) && !_currentConfig.handleSilentError) {
      _logger.info(
        'Report error skipped for error: $error. HandleSilentError is false.',
      );
      return;
    }

    if (_localizationOptions == null) {
      _logger.info('Setup localization lazily!');
      _setupLocalization();
    }

    _cleanPastReportsOccurrences();

    File? screenshot;
    if (!ApplicationProfileManager.isWeb()) {
      try {
        screenshot = await screenshotManager.captureAndSave();
      } catch (e) {
        _logger.warning('Failed to create screenshot file: $e');
      }
    }

    final report = Report(
      error,
      stackTrace,
      DateTime.now(),
      _deviceParameters,
      _applicationParameters,
      _currentConfig.customParameters,
      errorDetails,
      _getPlatformType(),
      screenshot,
    );

    if (_isReportInReportsOccurrencesMap(report)) {
      _logger.fine(
        "Error: '$error' has been skipped to due to duplication occurrence "
        'within ${_currentConfig.reportOccurrenceTimeout} ms.',
      );
      return;
    }

    if (_currentConfig.filterFunction != null &&
        !_currentConfig.filterFunction!(report)) {
      _logger.fine(
        "Error: '$error' has been filtered from Catcher 2 logs. "
        'Report will be skipped.',
      );
      return;
    }
    _cachedReports.add(report);
    var reportMode = _getReportModeFromExplicitExceptionReportModeMap(error);
    if (reportMode != null) {
      _logger.info('Using explicit report mode for error');
    } else {
      reportMode = _currentConfig.reportMode;
    }
    if (!isReportModeSupportedInPlatform(report, reportMode)) {
      _logger.warning(
        '$reportMode is not supported for ${report.platformType.name} platform',
      );
      return;
    }

    _addReportInReportsOccurrencesMap(report);

    if (reportMode.isContextRequired()) {
      if (_isContextValid()) {
        reportMode.requestAction(report, _getContext());
      } else {
        _logger.warning(
          "Couldn't use report mode because you didn't provide navigator key. "
          'Add navigator key to use this report mode.',
        );
      }
    } else {
      reportMode.requestAction(report, null);
    }
  }

  /// Check if given report mode is enabled in current platform. Only supported
  /// handlers in given report mode can be used.
  bool isReportModeSupportedInPlatform(Report report, ReportMode reportMode) =>
      reportMode.getSupportedPlatforms().contains(report.platformType);

  ReportMode? _getReportModeFromExplicitExceptionReportModeMap(error) {
    final errorName = error != null ? error.toString().toLowerCase() : '';
    ReportMode? reportMode;
    _currentConfig.explicitExceptionReportModesMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportMode = value;
        return;
      }
    });
    return reportMode;
  }

  ReportHandler? _getReportHandlerFromExplicitExceptionHandlerMap(
    error,
  ) {
    final errorName = error != null ? error.toString().toLowerCase() : '';
    ReportHandler? reportHandler;
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
    final reportHandler =
        _getReportHandlerFromExplicitExceptionHandlerMap(report.error);
    if (reportHandler != null) {
      _logger.info('Using explicit report handler');
      _handleReport(report, reportHandler);
      return;
    }

    for (final handler in _currentConfig.handlers) {
      _handleReport(report, handler);
    }
  }

  void _handleReport(Report report, ReportHandler reportHandler) {
    if (!isReportHandlerSupportedInPlatform(report, reportHandler)) {
      _logger.warning('$reportHandler in not supported for '
          '${report.platformType.name} platform');
      return;
    }

    if (reportHandler.isContextRequired() && !_isContextValid()) {
      _logger.warning(
        "Couldn't use report handler because you didn't provide navigator key. "
        'Add navigator key to use this report mode.',
      );
      return;
    }

    reportHandler.handle(report, _getContext()).catchError((handlerError) {
      _logger.warning('Error occurred in $reportHandler: $handlerError');
      return true; // Shut up warnings
    }).then((result) {
      _logger.info('${report.runtimeType} result: $result');
      if (!result) {
        _logger.warning('$reportHandler failed to report error');
      } else {
        _cachedReports.remove(report);
      }
    }).timeout(
      Duration(milliseconds: _currentConfig.handlerTimeout),
      onTimeout: () {
        _logger.warning(
          '$reportHandler failed to report error because of timeout',
        );
      },
    );
  }

  /// Checks is report handler is supported in given platform. Only supported
  /// report handlers in given platform can be used.
  bool isReportHandlerSupportedInPlatform(
    Report report,
    ReportHandler reportHandler,
  ) {
    if (reportHandler.getSupportedPlatforms().isEmpty) {
      return false;
    }
    return reportHandler.getSupportedPlatforms().contains(report.platformType);
  }

  @override
  void onActionRejected(Report report) {
    _currentConfig.handlers
        .where((handler) => handler.shouldHandleWhenRejected())
        .forEach((handler) {
      _handleReport(report, handler);
    });

    _cachedReports.remove(report);
  }

  BuildContext? _getContext() => navigatorKey?.currentState?.overlay?.context;

  bool _isContextValid() => navigatorKey?.currentState?.overlay != null;

  /// Get currently used config.
  Catcher2Options? getCurrentConfig() => _currentConfig;

  /// Send text exception. Used to test Catcher 2 configuration.
  static void sendTestException() {
    throw const FormatException('Test exception generated by Catcher 2');
  }

  /// Add default error widget which replaces red screen of death (RSOD).
  static void addDefaultErrorWidget({
    bool showStacktrace = true,
    String title = 'An application error has occurred',
    String description =
        'There was unexpected situation in application. Application has been '
            'able to recover from error state.',
    double maxWidthForSmallMode = 150,
  }) {
    ErrorWidget.builder = (details) => Catcher2ErrorWidget(
          details: details,
          showStacktrace: showStacktrace,
          title: title,
          description: description,
          maxWidthForSmallMode: maxWidthForSmallMode,
        );
  }

  /// Get platform type based on device.
  PlatformType _getPlatformType() {
    if (ApplicationProfileManager.isWeb()) {
      return PlatformType.web;
    }
    if (ApplicationProfileManager.isAndroid()) {
      return PlatformType.android;
    }
    if (ApplicationProfileManager.isIos()) {
      return PlatformType.iOS;
    }
    if (ApplicationProfileManager.isLinux()) {
      return PlatformType.linux;
    }
    if (ApplicationProfileManager.isWindows()) {
      return PlatformType.windows;
    }
    if (ApplicationProfileManager.isMacOS()) {
      return PlatformType.macOS;
    }

    return PlatformType.unknown;
  }

  /// Clean report occurrences from the past.
  void _cleanPastReportsOccurrences() {
    final occurrenceTimeout = _currentConfig.reportOccurrenceTimeout;
    final nowDateTime = DateTime.now();
    _reportsOccurrenceMap.removeWhere((key, value) {
      final occurrenceWithTimeout =
          key.add(Duration(milliseconds: occurrenceTimeout));
      return nowDateTime.isAfter(occurrenceWithTimeout);
    });
  }

  /// Check whether reports occurrence map contains given report.
  bool _isReportInReportsOccurrencesMap(Report report) {
    if (report.error != null) {
      return _reportsOccurrenceMap.containsValue(report.error.toString());
    } else {
      return false;
    }
  }

  /// Add report in reports occurrences map. Report will be added only when
  /// error is not null and report occurrence timeout is greater than 0.
  void _addReportInReportsOccurrencesMap(Report report) {
    if (report.error != null && _currentConfig.reportOccurrenceTimeout > 0) {
      _reportsOccurrenceMap[DateTime.now()] = report.error.toString();
    }
  }

  /// Get current Catcher 2 instance.
  static Catcher2 getInstance() => _instance;
}
