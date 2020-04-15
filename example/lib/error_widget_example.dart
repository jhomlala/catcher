import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    ConsoleHandler(),
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
      builder: (BuildContext context, Widget widget) {
        Catcher.addDefaultErrorWidget(
          showStacktrace: true,
          title: "Custom title",
          description: "Custom description",
          maxWidthForSmallMode: 150
        );
        return widget;
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _buildSmallErrorWidget(),
      ),
    );
  }

  ///Trigger "normal" mode
  Widget _buildNormalErrorWidget() {
    return ChildWidget();
  }

  ///Trigger "small" mode
  Widget _buildSmallErrorWidget() {
    return GridView.count(crossAxisCount: 3, children: [
      ChildWidget(),
      ChildWidget(),
      ChildWidget(),
    ]);
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlatButton(child: Text(null), onPressed: generateError));
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}
