import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/localization_options.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/model/report_mode.dart';

class CatcherOptions {
  /// Handlers that should be used
  final List<ReportHandler> handlers;

  /// Timeout for handlers which uses long-running action. In milliseconds.
  final int handlerTimeout;

  /// Report mode that should be called if new report appears
  final ReportMode reportMode;

  /// Localization options (translations)
  final List<LocalizationOptions> localizationOptions;

  /// Explicit report modes map which will be used to trigger specific report mode
  /// for specific error
  final Map<String, ReportMode> explicitExceptionReportModesMap;

  /// Explicit report handler map which will be used to trigger specific report
  /// report handler for specific error
  final Map<String, ReportHandler> explicitExceptionHandlersMap;

  /// Custom parameters which will be used in report handler
  final Map<String, dynamic> customParameters;

  ///Should catcher handle silent errors
  final bool handleSilentError;

  ///Path which will be used to save temp. screenshots. If not set, Catcher
  ///will use temp directory.
  final String screenshotsPath;

  ///Parameters which will be excluded from report
  final List<String> excludedParameters;

  /// Builds catcher options instance
  CatcherOptions(
    this.reportMode,
    this.handlers, {
    this.handlerTimeout = 5000,
    this.customParameters = const <String, dynamic>{},
    this.localizationOptions = const [],
    this.explicitExceptionReportModesMap = const {},
    this.explicitExceptionHandlersMap = const {},
    this.handleSilentError = true,
    this.screenshotsPath = "",
    this.excludedParameters = const [],
  });

  /// Builds default catcher options release instance
  CatcherOptions.getDefaultReleaseOptions()
      : handlers = [ConsoleHandler()],
        reportMode = DialogReportMode(),
        handlerTimeout = 5000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = "",
        this.excludedParameters = const [];

  /// Builds default catcher options debug instance
  CatcherOptions.getDefaultDebugOptions()
      : handlers = [ConsoleHandler()],
        reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = "",
        this.excludedParameters = const [];

  /// Builds default catcher options profile instance
  CatcherOptions.getDefaultProfileOptions()
      : handlers = [ConsoleHandler()],
        reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String, dynamic>{},
        localizationOptions = [],
        explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {},
        handleSilentError = true,
        screenshotsPath = "",
        this.excludedParameters = const [];
}
