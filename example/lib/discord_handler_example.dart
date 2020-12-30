import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    DiscordHandler("<web_hook_url>",
        enableDeviceParameters: true,
        enableApplicationParameters: true,
        enableCustomParameters: true,
        enableStackTrace: true,
        printLogs: true),
  ]);
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
        child: FlatButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}
