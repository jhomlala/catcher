import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = CatcherOptions(
    DialogReportMode(),
    [
      ConsoleHandler(),
    ],
    logger: CustomCatcherLogger(),
  );
  final releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
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
  const MyApp({super.key});

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
  const ChildWidget({super.key});

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

class CustomCatcherLogger extends CatcherLogger {
  @override
  void info(String message) {
    print('Custom Catcher Logger | Info | $message');
  }

  @override
  void fine(String message) {
    print('Custom Catcher Logger | Fine | $message');
  }

  @override
  void warning(String message) {
    print('Custom Catcher Logger | Warning | $message');
  }

  @override
  void severe(String message) {
    print('Custom Catcher Logger | Servere | $message');
  }
}
