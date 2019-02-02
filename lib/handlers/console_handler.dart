import 'package:catcher/model/report.dart';
import 'package:catcher/handlers/report_handler.dart';

class ConsoleHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  const ConsoleHandler(
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = false});

  @override
  Future<bool> handle(Report error) {
    print(
        "============================== CATCHER LOG ==============================");
    print("Crash occured on ${error.dateTime}");
    print("");
    if (enableDeviceParameters) {
      printDeviceParametersFormatted(error.deviceParameters);
      print("");
    }
    if (enableApplicationParameters) {
      printApplicationParametersFormatted(error.applicationParameters);
      print("");
    }
    print("---------- ERROR ----------");
    print("${error.error}");
    print("");
    if (enableStackTrace) {
      print("------- STACK TRACE -------");
      print("${error.stackTrace}");
    }
    if (enableCustomParameters) {
      printCustomParametersFormatted(error.customParameters);
    }
    print(
        "======================================================================");
    return Future.value(true);
  }

  printDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    print("------- DEVICE INFO -------");
    for (var entry in deviceParameters.entries) {
      print("${entry.key}: ${entry.value}");
    }
  }

  printApplicationParametersFormatted(
      Map<String, dynamic> applicationParameters) {
    print("------- APP INFO -------");
    for (var entry in applicationParameters.entries) {
      print("${entry.key}: ${entry.value}");
    }
  }

  printCustomParametersFormatted(Map<String, dynamic> customParameters) {
    print("------- CUSTOM INFO -------");
    for (var entry in customParameters.entries) {
      print("${entry.key}: ${entry.value}");
    }
  }
}
