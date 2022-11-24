import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  var explicitReportModesMap = {"FormatException": PageReportMode()};
  CatcherOptions debugOptions = CatcherOptions(
    DialogReportMode(),
    [
      ConsoleHandler(),
      HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
          printLogs: true)
    ],
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(
    rootWidget: MyApp(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
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
      child: Column(children: <Widget>[
        TextButton(
            child: Text("Generate first error"),
            onPressed: () => generateFirstError()),
        TextButton(
          child: Text("Generate second error"),
          onPressed: () => generateSecondError(),
        )
      ]),
    );
  }

  void generateFirstError() async {
    throw new FormatException("Example Error");
  }

  void generateSecondError() async {
    throw new ArgumentError("Normal error");
  }
}
