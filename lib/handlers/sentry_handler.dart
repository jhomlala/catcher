import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:logging/logging.dart';
import 'package:sentry/sentry.dart';

class SentryHandler extends ReportHandler {
  final SentryClient sentryClient;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableCustomParameters;
  final bool printLogs;
  final Logger _logger = Logger("SentryHandler");

  SentryHandler(this.sentryClient,
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableCustomParameters = true,
      this.printLogs = true})
      : assert(sentryClient != null, "sentryClient can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  Future<bool> handle(Report error) async {
    try {
      _printLog("Logging to sentry...");

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

      var event = buildEvent(error, tags);
      final sentryResult = await sentryClient.capture(event: event);

      if (!sentryResult.isSuccessful) {
        throw Exception(sentryResult.error);
      }
      _printLog("Logged to sentry!");
      return true;
    } catch (exception) {
      _printLog("Failed to send sentry event: $exception");
      return false;
    }
  }

  String _getApplicationVersion(Report report) {
    String applicationVersion = "";
    var applicationParameters = report.applicationParameters;
    if (applicationParameters.containsKey("appName")) {
      applicationVersion += applicationParameters["appName"];
    }
    if (applicationParameters.containsKey("version")) {
      applicationVersion += " ${applicationParameters["version"]}";
    }
    if (applicationVersion.isEmpty) {
      applicationVersion = "?";
    }
    return applicationVersion;
  }

  Event buildEvent(Report report, Map<String, dynamic> tags) {
    return Event(
      loggerName: "Catcher",
      serverName: "Catcher",
      release: _getApplicationVersion(report),
      environment: report.applicationParameters["environment"],
      message: "Error handled by Catcher",
      exception: report.error,
      stackTrace: report.stackTrace,
      level: SeverityLevel.error,
      culprit: "",
      tags: changeToSentryMap(tags),
    );
  }

  Map<String, String> changeToSentryMap(Map<String, dynamic> map) {
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

  void _printLog(String message) {
    if (printLogs) {
      _logger.info(message);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}
