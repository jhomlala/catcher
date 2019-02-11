import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
    HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
        printLogs: true)
  ]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);
  CatcherOptions profileOptions = CatcherOptions(
    NotificationReportMode(),
    [ConsoleHandler(), ToastHandler()],
    handlerTimeout: 10000,
    customParameters: {"example": "example_parameter"},
  );

  Catcher(MyApp(),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions,
      profileConfig: profileOptions);
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
    throw "Test exception";
  }
}
