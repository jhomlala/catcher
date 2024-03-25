import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(
    DialogReportMode(),
    [
      ConsoleHandler(),
    ],
    logger: CustomCatcher2Logger(),
  );
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  Catcher2(
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: Catcher2.navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: const ChildWidget(),
        ),
      );
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: generateError,
        child: const Text('Generate error'),
      );

  Future<void> generateError() async {
    Catcher2.sendTestException();
  }
}

class CustomCatcher2Logger extends Catcher2Logger {
  @override
  void info(String message) {
    // ignore: avoid_print
    print('Custom Catcher Logger | Info | $message');
  }

  @override
  void fine(String message) {
    // ignore: avoid_print
    print('Custom Catcher Logger | Fine | $message');
  }

  @override
  void warning(String message) {
    // ignore: avoid_print
    print('Custom Catcher Logger | Warning | $message');
  }

  @override
  void severe(String message) {
    // ignore: avoid_print
    print('Custom Catcher Logger | Severe | $message');
  }
}
