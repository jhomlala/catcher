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
      // ignore: unnecessary_null_comparison
      : assert(enableDeviceParameters != null,
            // ignore: unnecessary_null_comparison
            "enableDeviceParameters can't be null"),
        // ignore: unnecessary_null_comparison
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        // ignore: unnecessary_null_comparison
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        // ignore: unnecessary_null_comparison
        assert(printLogs != null, "printLogs can't be null");
  @override
  List<PlatformType> getSupportedPlatforms() {
    return [PlatformType.android, PlatformType.iOS];
  }

  
  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    try {
      _printLog("Sending crashlytics report");
      final crashlytics = FirebaseCrashlytics.instance;
      crashlytics.setCrashlyticsCollectionEnabled(true);
      crashlytics.log(_getLogMessage(report));
      if (report.errorDetails != null) {
        // ignore: cast_nullable_to_non_nullable
        await crashlytics.recordFlutterError(report.errorDetails as
        FlutterErrorDetails);
      } else {
        await crashlytics.recordError(report.error, report.stackTrace as
         StackTrace);
      }
      _printLog("Crashlytics report sent");
      return true;
    } catch (exception) {
      _printLog("Failed to send crashlytics report: $exception" );
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
      child: TextButton(
        child: Text("Generate error"),
        onPressed: () => generateError(),
      ),
    );
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}*/
