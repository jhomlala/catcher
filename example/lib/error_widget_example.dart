import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    ConsoleHandler(),
    HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
        printLogs: true)
  ]);
  CatcherOptions releaseOptions = CatcherOptions(NotificationReportMode(), [
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
      builder: (BuildContext context, Widget widget) {
        Catcher.addDefaultErrorWidget(
            showStacktrace: true,
            customTitle: "Custom error title",
            customDescription: "Custom error description");
        return widget;
      },
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
        child: FlatButton(child: Text(null), onPressed: () => generateError()));
  }

  generateError() async {
    Catcher.sendTestException();
  }
}
