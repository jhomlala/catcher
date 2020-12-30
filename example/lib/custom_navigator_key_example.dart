import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["recipient@email.com"]),
    ConsoleHandler()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Catcher(
    rootWidget: MyApp(navigatorKey),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
    navigatorKey: navigatorKey,
  );
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp(this.navigatorKey);

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
      navigatorKey: widget.navigatorKey,
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
