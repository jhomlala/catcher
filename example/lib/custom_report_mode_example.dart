import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(CustomPageReportMode(), [
    EmailManualHandler(["recipient@email.com"]),
    ConsoleHandler()
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

class CustomPageReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _navigateToPageWidget(report, context);
  }

  _navigateToPageWidget(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomPage(this, report)),
    );
  }

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}

class CustomPage extends StatelessWidget {
  final ReportMode reportMode;
  final Report report;

  CustomPage(this.reportMode, this.report);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Container(
          child: Row(children: [
            RaisedButton(
              child: Text("Send report"),
              onPressed: () {
                reportMode.onActionConfirmed(report);
              },
            ),
            RaisedButton(
              child: Text("Cancel report"),
              onPressed: () {
                reportMode.onActionRejected(report);
                Navigator.pop(context);
              },
            )
          ]),
        ));
  }
}
