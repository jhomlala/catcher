import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

main() {
  ///Http handler instance
  var httpHandler = HttpHandler(
    HttpRequestType.post,
    Uri.parse("https://jsonplaceholder.typicode.com/posts"),
    printLogs: true,
    enableCustomParameters: false,
    enableStackTrace: false,
    enableApplicationParameters: false,
    enableDeviceParameters: false,
  );

  ///Init catcher
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [httpHandler, ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);

  ///At some point of time, you're updating headers:

  httpHandler.headers.clear();
  httpHandler.headers["my_header"] = "Test";
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
