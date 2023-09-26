import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final explicitReportModesMap = {'FormatException': PageReportMode()};
  final debugOptions = Catcher2Options(
    DialogReportMode(),
    [
      ConsoleHandler(),
      HttpHandler(
        HttpRequestType.post,
        Uri.parse('https://httpstat.us/200'),
        printLogs: true,
      ),
    ],
    explicitExceptionReportModesMap: explicitReportModesMap,
  );
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  Catcher2(
    rootWidget: const MyApp(),
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
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          TextButton(
            onPressed: generateFirstError,
            child: const Text('Generate first error'),
          ),
          TextButton(
            onPressed: generateSecondError,
            child: const Text('Generate second error'),
          ),
        ],
      );

  Future<void> generateFirstError() async {
    throw const FormatException('Example Error');
  }

  Future<void> generateSecondError() async {
    throw ArgumentError('Normal error');
  }
}
