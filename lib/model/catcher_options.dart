import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/mode/notification_report_mode.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/report_mode.dart';

class CatcherOptions {
  final List<ReportHandler> handlers;
  final int handlerTimeout;
  final ReportMode reportMode;
  final Map<String, dynamic> customParameters;

  CatcherOptions(this.reportMode, this.handlers,
      {this.handlerTimeout = 5000, this.customParameters = const {}});

  CatcherOptions.getDefaultReleaseOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = NotificationReportMode(),
        handlerTimeout = 5000,
        customParameters = Map();

  CatcherOptions.getDefaultDebugOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = Map();

  CatcherOptions.getDefaultProfileOptions()
      : this.handlers = [ConsoleHandler()],
        this.reportMode = SilentReportMode(),
        handlerTimeout = 10000,
        customParameters = Map();
}
