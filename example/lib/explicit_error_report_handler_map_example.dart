import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final explicitMap = {'FormatException': ConsoleHandler()};
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
    explicitExceptionHandlersMap: explicitMap,
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
  Widget build(BuildContext context) => TextButton(
        onPressed: generateError,
        child: const Text('Generate error'),
      );

  Future<void> generateError() async {
    throw const FormatException('Example Error');
  }
}
