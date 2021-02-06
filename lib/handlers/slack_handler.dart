import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class SlackHandler extends ReportHandler {
  final Dio _dio = Dio();
  final Logger _logger = Logger("SlackHandler");

  final String webhookUrl;
  final String channel;
  final String username;
  final String iconEmoji;

  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  SlackHandler(this.webhookUrl, this.channel,
      {this.username = "Catcher",
      this.iconEmoji = ":bangbang:",
      this.printLogs = false,
      this.enableDeviceParameters = false,
      this.enableApplicationParameters = false,
      this.enableStackTrace = false,
      this.enableCustomParameters = false})
      : assert(webhookUrl != null, "webhookUrl can't be null"),
        assert(channel != null, "channel can't be null"),
        assert(username != null, "username can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  Future<bool> handle(Report report) async {
    try {
      if (!(await CatcherUtils.isInternetConnectionAvailable())) {
        _printLog("No internet connection available");
        return false;
      }

      final String message = _buildMessage(report);
      final data = {
        "text": message,
        "channel": channel,
        "username": username,
        "icon_emoji": iconEmoji
      };
      _printLog("Sending request to Slack server...");
      final Response response =
          await _dio.post<dynamic>(webhookUrl, data: data);
      _printLog(
          "Server responded with code: ${response.statusCode} and message: ${response.statusMessage}");
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (exception) {
      _printLog("Failed to send slack message: $exception");
      return false;
    }
  }

  String _buildMessage(Report report) {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("*Error:* ```${report.error}```\n");
    if (enableStackTrace) {
      stringBuffer.write("*Stack trace:* ```${report.stackTrace}```\n");
    }
    if (enableDeviceParameters && report.deviceParameters.isNotEmpty) {
      stringBuffer.write("*Device parameters:* ```");
      for (final entry in report.deviceParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }

    if (enableApplicationParameters &&
        report.applicationParameters.isNotEmpty) {
      stringBuffer.write("*Application parameters:* ```");
      for (final entry in report.applicationParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }

    if (enableCustomParameters && report.customParameters.isNotEmpty) {
      stringBuffer.write("*Custom parameters:* ```");
      for (final entry in report.customParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }
    return stringBuffer.toString();
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}
