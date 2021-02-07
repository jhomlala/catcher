import 'package:catcher/catcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    //EmailManualHandler(["recipient@email.com"]),
    HttpHandler(HttpRequestType.post,
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        printLogs: true),
    ConsoleHandler()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(
      rootWidget: MyApp(),
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
    return CupertinoApp(
      navigatorKey: Catcher.navigatorKey,
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Cupertino example'),
        ),
        child: SafeArea(
          child: ChildWidget(),
        ),
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
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
