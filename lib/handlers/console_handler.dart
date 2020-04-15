import 'package:catcher/model/report.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:logging/logging.dart';

class ConsoleHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  Logger _logger = Logger("ConsoleHandler");

  ConsoleHandler(
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = false})
      : assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null");

  @override
  Future<bool> handle(Report error) {
    _logger.info(
        "============================== CATCHER LOG ==============================");
    _logger.info("Crash occured on ${error.dateTime}");
    _logger.info("");
    if (enableDeviceParameters) {
      _printDeviceParametersFormatted(error.deviceParameters);
      _logger.info("");
    }
    if (enableApplicationParameters) {
      _printApplicationParametersFormatted(error.applicationParameters);
      _logger.info("");
    }
    _logger.info("---------- ERROR ----------");
    _logger.info("${error.error}");
    _logger.info("");
    if (enableStackTrace) {
      _printStackTraceFormatted(error.stackTrace);
    }
    if (enableCustomParameters) {
      _printCustomParametersFormatted(error.customParameters);
    }
    _logger.info(
        "======================================================================");
    return Future.value(true);
  }

  void _printDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    _logger.info("------- DEVICE INFO -------");
    for (var entry in deviceParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printApplicationParametersFormatted(
      Map<String, dynamic> applicationParameters) {
    _logger.info("------- APP INFO -------");
    for (var entry in applicationParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printCustomParametersFormatted(Map<String, dynamic> customParameters) {
    _logger.info("------- CUSTOM INFO -------");
    for (var entry in customParameters.entries) {
      _logger.info("${entry.key}: ${entry.value}");
    }
  }

  void _printStackTraceFormatted(StackTrace stackTrace) {
    _logger.info("------- STACK TRACE -------");
    for (var entry in stackTrace.toString().split("\n")) {
      _logger.info("$entry");
    }
  }
}
