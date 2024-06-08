import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = CatcherOptions(
    DialogReportMode(),
    [
      ConsoleHandler(),
      ToastHandler(),
    ],
    filterFunction: (Report report) {
      if (report.error is ArgumentError) {
        return false;
      } else {
        return true;
      }
    },
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
          title: const Text('Filter example'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: generateNormalError,
              child: const Text('Generate normal error'),
            ),
            TextButton(
              onPressed: generateFilteredError,
              child: const Text('Generate filtered error'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateNormalError() async {
    throw StateError('Example error');
  }

  Future<void> generateFilteredError() async {
    throw ArgumentError('Example error');
  }
}
