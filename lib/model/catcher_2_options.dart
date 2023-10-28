import 'package:catcher_2/handlers/console_handler.dart';
import 'package:catcher_2/mode/dialog_report_mode.dart';
import 'package:catcher_2/mode/silent_report_mode.dart';
import 'package:catcher_2/model/localization_options.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/model/report_mode.dart';
import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:flutter/foundation.dart';

class Catcher2Options {
  /// Builds catcher 2 options instance
  Catcher2Options(
    this.reportMode,
    this.handlers, {
    this.handlerTimeout = 5000,
    this.customParameters = const <String, dynamic>{},
    this.localizationOptions = const [],
    this.explicitExceptionReportModesMap = const {},
    this.explicitExceptionHandlersMap = const {},
    this.handleSilentError = true,
    this.screenshotsPath = '',
    this.excludedParameters = const [],
    this.filterFunction,
    this.reportOccurrenceTimeout = 3000,
    this.onFlutterError,
    this.onPlatformError,
    this.logger,
  });

  /// Builds default catcher 2 options release instance
  Catcher2Options.getDefaultReleaseOptions()
      : handlers = [ConsoleHandler()],
        reportMode = DialogReportMode(),
        handlerTimeout = 5000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = '',
        excludedParameters = const [],
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        onFlutterError = null,
        onPlatformError = null,
        logger = Catcher2Logger();

  /// Builds default catcher 2 options debug instance
  Catcher2Options.getDefaultDebugOptions()
      : handlers = [ConsoleHandler()],
        reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = '',
        excludedParameters = const [],
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        onFlutterError = null,
        onPlatformError = null,
        logger = Catcher2Logger();

  /// Builds default catcher 2 options profile instance
  Catcher2Options.getDefaultProfileOptions()
      : handlers = [ConsoleHandler()],
        reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = '',
        excludedParameters = const [],
        filterFunction = null,
        reportOccurrenceTimeout = 3000,
        onFlutterError = null,
        onPlatformError = null,
        logger = Catcher2Logger();

  /// Handlers that should be used
  final List<ReportHandler> handlers;

  /// Timeout for handlers which uses long-running action. In milliseconds.
  final int handlerTimeout;

  /// Report mode that should be called if new report appears
  final ReportMode reportMode;

  /// Localization options (translations)
  final List<LocalizationOptions> localizationOptions;

  /// Explicit report modes map which will be used to trigger specific report
  /// mode for specific error
  final Map<String, ReportMode> explicitExceptionReportModesMap;

  /// Explicit report handler map which will be used to trigger specific report
  /// report handler for specific error
  final Map<String, ReportHandler> explicitExceptionHandlersMap;

  /// Custom parameters which will be used in report handler
  final Map<String, dynamic> customParameters;

  /// Should catcher 2 handle silent errors
  final bool handleSilentError;

  /// Path which will be used to save temp. screenshots. If not set, Catcher 2
  /// will use temp directory.
  final String screenshotsPath;

  /// Parameters which will be excluded from report
  final List<String> excludedParameters;

  /// Function which is used to filter reports. If [filterFunction] is empty
  /// then all reports will be passed to handlers.
  /// To mark given Report as valid, [filterFunction] should return true,
  /// otherwise return false.
  final bool Function(Report report)? filterFunction;

  /// Timeout for reports to prevent handling duplicates of same error. In
  /// milliseconds.
  final int reportOccurrenceTimeout;

  /// Function which should additionally be called when an error is caught using
  /// the [FlutterError.onError] mechanism. Useful if other packages also need
  /// to override this behaviour (such as integration tests).
  final void Function(FlutterErrorDetails details)? onFlutterError;

  /// Function which should additionally be called when an error is caught using
  /// the [PlatformDispatcher.instance.onError] mechanism. Useful if other
  /// packages also need to override this behaviour.
  final void Function(Object error, StackTrace stack)? onPlatformError;

  /// Logger instance.
  final Catcher2Logger? logger;
}
