import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/localization_options.dart';
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

  /// Builds catcher options instance
  CatcherOptions(this.reportMode, this.handlers,
      {this.handlerTimeout = 5000,
      this.customParameters = const <String,dynamic>{},
      this.localizationOptions = const [],
      this.explicitExceptionReportModesMap = const {},
      this.explicitExceptionHandlersMap = const {}});

  /// Builds default catcher options release instance
  CatcherOptions.getDefaultReleaseOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = DialogReportMode(),
        handlerTimeout = 5000,
        customParameters = <String,dynamic>{},
        localizationOptions = [],
        this.explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {};

  /// Builds default catcher options rdebug instance
  CatcherOptions.getDefaultDebugOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String,dynamic>{},
        localizationOptions = [],
        this.explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {};

  /// Builds default catcher options profile instance
  CatcherOptions.getDefaultProfileOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = <String,dynamic>{},
        localizationOptions = [],
        this.explicitExceptionReportModesMap = {},
        explicitExceptionHandlersMap = {};
}
