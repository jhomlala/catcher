import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["email1@email.com", "email2@email.com"],
        enableDeviceParameters: true,
        enableStackTrace: true,
        enableCustomParameters: true,
        enableApplicationParameters: true,
        sendHtml: true,
        emailTitle: "Sample Title",
        emailHeader: "Sample Header",
        printLogs: true)
  ], customParameters: {
    "Test": "Test12345",
    "Test2": "Test54321"
  });

  Catcher(
    rootWidget: MyApp(),
    debugConfig: debugOptions,
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

  generateError() async {
    throw "Test exception";
  }
}
