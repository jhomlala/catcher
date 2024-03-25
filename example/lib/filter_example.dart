import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(
    DialogReportMode(),
    [
      ConsoleHandler(),
      ToastHandler(),
    ],
    filterFunction: (report) {
      if (report.error is ArgumentError) {
        return false;
      } else {
        return true;
      }
    },
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

  Future<void> generateNormalError() async {
    throw StateError('Example error');
  }

  Future<void> generateFilteredError() async {
    throw ArgumentError('Example error');
  }
}
