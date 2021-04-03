import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(
    DialogReportMode(),
    [
      //EmailManualHandler(["recipient@email.com"]),
      ToastHandler(),
      HttpHandler(HttpRequestType.post,
          Uri.parse("https://jsonplaceholder.typicode.com/posts"),
          printLogs: true),
      ConsoleHandler()
    ],

    //Exclude these parameters from report. These params are device info params.
    excludedParameters: ["androidId", "model"],
  );
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(
      runAppFunction: () {
        runApp(MyApp());
      },
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
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
}
