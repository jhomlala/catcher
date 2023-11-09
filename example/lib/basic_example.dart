import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
  ]);
  final releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(['recipient@e mail.com']),
  ]);

  Catcher(
    runAppFunction: () {
      runApp(const MyApp());
    },
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
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
        body: const ChildWidget(),
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: generateError,
      child: const Text('Generate error'),
    );
  }

  Future<void> generateError() async {
    Catcher.sendTestException();
  }
}
