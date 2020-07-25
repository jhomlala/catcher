/*import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:catcher/catcher.dart';

class CrashlyticsHandler extends ReportHandler {
  final Logger _logger = Logger("CrashlyticsHandler");

  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableCustomParameters;
  final bool printLogs;

  CrashlyticsHandler(
      {this.enableDeviceParameters = true,
        this.enableApplicationParameters = true,
        this.enableCustomParameters = true,
        this.printLogs = true})
      : assert(enableDeviceParameters != null,
  "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
        "enableApplicationParameters can't be null"),
        assert(enableCustomParameters != null,
        "enableCustomParameters can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  List<PlatformType> getSupportedPlatforms() {
    return [PlatformType.Android, PlatformType.iOS];
  }

  @override
  Future<bool> handle(Report report) async {
    try {
      _printLog("Sending crashlytics report");
      var crashlytics = Crashlytics.instance;
      crashlytics.enableInDevMode = true;
      crashlytics.log(_getLogMessage(report));

      if (report.errorDetails != null) {
        await crashlytics.recordFlutterError(report.errorDetails);
      } else {
        await crashlytics.recordError(report.error, report.stackTrace);
      }
      _printLog("Crashlytics report sent");

      return true;
    } catch (exception) {
      _printLog("Failed to send crashlytics report: " + exception);
      return false;
    }
  }

  String _getLogMessage(Report report) {
    StringBuffer buffer = StringBuffer("");
    if (enableDeviceParameters) {
      buffer.write("||| Device parameters ||| ");
      for (var entry in report.deviceParameters.entries) {
        buffer.write("${entry.key}: ${entry.value} ");
      }
    }
    if (enableApplicationParameters) {
      buffer.write("||| Application parameters ||| ");
      for (var entry in report.applicationParameters.entries) {
        buffer.write("${entry.key}: ${entry.value} ");
      }
    }

    if (enableCustomParameters) {
      buffer.write("||| Custom parameters ||| ");
      for (var entry in report.customParameters.entries) {
        buffer.write("${entry.key}: ${entry.value} ");
      }
    }

    return buffer.toString();
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }
}


main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    CrashlyticsHandler(),
    ConsoleHandler()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Generate error"),
        onPressed: () => generateError(),
      ),
    );
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}*/
