import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/report.dart';
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
      this.enableCustomParameters = false}) {
    assert(webhookUrl != null, "Webhook must be specified");
    assert(channel != null, "Channel must be specified");
  }

  @override
  Future<bool> handle(Report report) async {
    if (!(await CatcherUtils.isInternetConnectionAvailable())) {
      _printLog("No internet connection available");
      return false;
    }

    StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.write("*Error:* ```${report.error}```\n");
    if (enableStackTrace) {
      stringBuffer.write("*Stack trace:* ```${report.stackTrace}```\n");
    }
    if (enableDeviceParameters && report.deviceParameters.length > 0) {
      stringBuffer.write("*Device parameters:* ```");
      for (var entry in report.deviceParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }

    if (enableApplicationParameters &&
        report.applicationParameters.length > 0) {
      stringBuffer.write("*Application parameters:* ```");
      for (var entry in report.applicationParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }

    if (enableCustomParameters && report.customParameters.length > 0) {
      stringBuffer.write("*Custom parameters:* ```");
      for (var entry in report.customParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("```\n");
    }

    String message = stringBuffer.toString();
    var data = {
      "text": message,
      "channel": channel,
      "username": username,
      "icon_emoji": iconEmoji
    };
    _printLog("Sending request to Slack server...");
    Response response = await _dio.post(webhookUrl, data: data);
    _printLog(
        "Server responded with code: ${response.statusCode} and message: ${response.statusMessage}");
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }
}
