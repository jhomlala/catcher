import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

main() {
  //silent:
  //ReportMode reportMode = SilentReportMode();

  //notification:
  //ReportMode reportMode = NotificationReportMode();

  //dialog:
  /*ReportMode reportMode = DialogReportMode(
      titleText: "Crash",
      descriptionText: "My description",
      acceptText: "OK",
      cancelText: "Back");*/

  //page:
  ReportMode reportMode = PageReportMode(
      showStackTrace: false);

  CatcherOptions debugOptions = CatcherOptions(reportMode, [ConsoleHandler()]);

  Catcher(MyApp(), debugConfig: debugOptions);
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
