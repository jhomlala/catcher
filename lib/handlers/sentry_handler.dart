import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/report.dart';
import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

class SentryHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableCustomParameters;
  final bool printLogs;
  final Logger _logger = Logger("SentryHandler");
  SentryClient sentry;

  SentryHandler(String dsn,
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableCustomParameters = true,
      this.printLogs = true}) {
    try {
      if (dsn == null || dsn.isEmpty || dsn == "") {
        _printLog("DSN is empty. Sentry handler won't work!");
      }
      sentry = SentryClient(dsn: dsn);
    } catch(exception){
      _printLog("Exception in sentry handler init: $exception");
    }
  }

  @override
  Future<bool> handle(Report error) async {
    try {
      _printLog("Logging to sentry...");
      await sentry.captureException(
          exception: error.error, stackTrace: error.stackTrace);
      String applicationVersion = error.applicationParameters["appName"] +
          " " +
          error.applicationParameters["version"];
      var tags = Map<String, dynamic>();
      if (enableApplicationParameters) {
        tags.addAll(error.applicationParameters);
      }
      if (enableDeviceParameters) {
        tags.addAll(error.deviceParameters);
      }
      if (enableCustomParameters) {
        tags.addAll(error.customParameters);
      }

      var event = Event(
        loggerName: "Catcher",
        serverName: "Catcher",
        release: applicationVersion,
        environment: error.applicationParameters["environment"],
        message: "Error handled by Catcher",
        exception: error.error,
        stackTrace: error.stackTrace,
        level: SeverityLevel.error,
        culprit: "",
        tags: _changeToSentryMap(tags),
      );
      await sentry.capture(event: event);
      _printLog("Logged to sentry!");
      return true;
    } catch (exception) {
      _printLog("Failed to send sentry event: $exception");
      return false;
    }
  }

  Map<String, String> _changeToSentryMap(Map<String, dynamic> map) {
    var sentryMap = Map<String, String>();
    map.forEach((key, value) {
      if (value.toString() == null || value.toString().isEmpty) {
        sentryMap[key] = "none";
      } else {
        sentryMap[key] = value.toString();
      }
    });
    return sentryMap;
  }

  void _printLog(String message){
    if (printLogs) {
      _logger.info(message);
    }
  }
}
