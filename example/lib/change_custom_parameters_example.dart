import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

Catcher catcher;

void main() {
  Map<String, dynamic> customParameters = new Map<String, dynamic>();
  customParameters["First"] = "First parameter";
  CatcherOptions debugOptions = CatcherOptions(
      PageReportMode(),
      [
        ConsoleHandler(enableCustomParameters: true),
      ],
      customParameters: customParameters);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  catcher = Catcher(
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
        child: Column(children: [
      ElevatedButton(
          child: Text("Change custom parameters"),
          onPressed: _changeCustomParameters),
      ElevatedButton(
          child: Text("Generate error"), onPressed: () => generateError())
    ]));
  }

  void generateError() async {
    Catcher.sendTestException();
  }

  void _changeCustomParameters() {
    CatcherOptions options = catcher.getCurrentConfig();
    options.customParameters["Second"] = "Second parameter";
  }
}
