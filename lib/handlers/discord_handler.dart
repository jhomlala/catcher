import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class DiscordHandler extends ReportHandler {
  final Dio _dio = Dio();
  final Logger _logger = Logger("DiscordHandler");

  final String webhookUrl;

  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  DiscordHandler(
    this.webhookUrl, {
    this.printLogs = false,
    this.enableDeviceParameters = false,
    this.enableApplicationParameters = false,
    this.enableStackTrace = false,
    this.enableCustomParameters = false,
  })  : assert(webhookUrl != null, "webhookUrl can't be null"),
        assert(printLogs != null, "printLogs can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null");

  @override
  Future<bool> handle(Report report) async {
    if (!(await CatcherUtils.isInternetConnectionAvailable())) {
      _printLog("No internet connection available");
      return false;
    }

    String message = _setupMessage(report);
    List<String> messages = _setupMessages(message);

    for (var value in messages) {
      bool result = await _sendContent(value);
      if (!result) {
        return result;
      }
    }

    return true;
  }

  List<String> _setupMessages(String message) {
    List<String> messages = List();
    int splits = (message.length / 2000).ceil();
    int messageLength = message.length;
    for (int index = 0; index < splits; index++) {
      int startIndex = index * 2000;
      int endIndex = startIndex + 2000;
      if (endIndex > messageLength) {
        endIndex = messageLength;
      }
      messages.add(message.substring(startIndex, endIndex));
    }
    return messages;
  }

  String _setupMessage(Report report) {
    StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.write("**Error:**\n${report.error}\n\n");
    if (enableStackTrace) {
      stringBuffer.write("**Stack trace:**\n${report.stackTrace}\n\n");
    }
    if (enableDeviceParameters && report.deviceParameters.length > 0) {
      stringBuffer.write("**Device parameters:**\n");
      for (var entry in report.deviceParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }

    if (enableApplicationParameters &&
        report.applicationParameters.length > 0) {
      stringBuffer.write("**Application parameters:**\n");
      for (var entry in report.applicationParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }

    if (enableCustomParameters && report.customParameters.length > 0) {
      stringBuffer.write("**Custom parameters:**\n");
      for (var entry in report.customParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }
    return stringBuffer.toString();
  }

  Future<bool> _sendContent(String content) async {
    try {
      var data = {
        "content": content,
      };
      _printLog("Sending request to Discord server...");
      Response response = await _dio.post(webhookUrl, data: data);
      _printLog(
          "Server responded with code: ${response
              .statusCode} and message: ${response.statusMessage}");
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (exception){
      _printLog("Failed to send data to Discord server: $exception");
      return false;
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }
}
