import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    SlackHandler("<web_hook_url>", "#catcher",
        username: "CatcherTest",
        iconEmoji: ":thinking_face:",
        enableDeviceParameters: true,
        enableApplicationParameters: true,
        enableCustomParameters: true,
        enableStackTrace: true,
        printLogs: true),
    //ConsoleHandler()
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
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  generateError() async {
    Catcher.sendTestException();
  }
}
