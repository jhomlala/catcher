import 'package:catcher/report.dart';
import 'package:catcher/handlers/report_handler.dart';

class ConsoleHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;

  const ConsoleHandler(
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true});

  @override
  bool handle(Report error) {
    print(
        "============================== CATCHER LOG ==============================");
    print("Crash occured on ${DateTime.now()}");
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
    print("Error: ${error.error}");
    print("");
    if (enableStackTrace) {
      print("------- STACK TRACE -------");
      print("StackTrace: ${error.stackTrace}");
    }
    print(
        "======================================================================");
    return true;
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
}
