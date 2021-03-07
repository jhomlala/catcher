import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
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
  });

  @override
  Future<bool> handle(Report report) async {
    if (report.platformType != PlatformType.web) {
      if (!(await CatcherUtils.isInternetConnectionAvailable())) {
        _printLog("No internet connection available");
        return false;
      }
    }

    final String message = _setupMessage(report);
    final List<String> messages = _setupMessages(message);

    for (final value in messages) {
      final bool result = await _sendContent(value);
      if (!result) {
        return result;
      }
    }

    return true;
  }

  List<String> _setupMessages(String message) {
    final List<String> messages = [];
    final int splits = (message.length / 2000).ceil();
    final int messageLength = message.length;
    for (int index = 0; index < splits; index++) {
      final int startIndex = index * 2000;
      int endIndex = startIndex + 2000;
      if (endIndex > messageLength) {
        endIndex = messageLength;
      }
      messages.add(message.substring(startIndex, endIndex));
    }
    return messages;
  }

  String _setupMessage(Report report) {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("**Error:**\n${report.error}\n\n");
    if (enableStackTrace) {
      stringBuffer.write("**Stack trace:**\n${report.stackTrace}\n\n");
    }
    if (enableDeviceParameters && report.deviceParameters.isNotEmpty) {
      stringBuffer.write("**Device parameters:**\n");
      for (final entry in report.deviceParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }

    if (enableApplicationParameters &&
        report.applicationParameters.isNotEmpty) {
      stringBuffer.write("**Application parameters:**\n");
      for (final entry in report.applicationParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }

    if (enableCustomParameters && report.customParameters.isNotEmpty) {
      stringBuffer.write("**Custom parameters:**\n");
      for (final entry in report.customParameters.entries) {
        stringBuffer.write("${entry.key}: ${entry.value}\n");
      }
      stringBuffer.write("\n\n");
    }
    return stringBuffer.toString();
  }

  Future<bool> _sendContent(String content) async {
    try {
      final data = {
        "content": content,
      };
      _printLog("Sending request to Discord server...");
      final Response response =
          await _dio.post<dynamic>(webhookUrl, data: data);
      _printLog(
          "Server responded with code: ${response.statusCode} and message: ${response.statusMessage}");
      final statusCode = response.statusCode ?? 0;
      return statusCode >= 200 && statusCode < 300;
    } catch (exception) {
      _printLog("Failed to send data to Discord server: $exception");
      return false;
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.web, PlatformType.android, PlatformType.iOS];
}
