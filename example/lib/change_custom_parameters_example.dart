import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

late Catcher catcher;

void main() {
  final customParameters = <String, dynamic>{};
  customParameters['First'] = 'First parameter';
  final debugOptions = CatcherOptions(
    PageReportMode(),
    [
      ConsoleHandler(enableCustomParameters: true),
    ],
    customParameters: customParameters,
  );
  final releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  catcher = Catcher(
    rootWidget: const MyApp(),
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
    return Column(
      children: [
        ElevatedButton(
          onPressed: _changeCustomParameters,
          child: const Text('Change custom parameters'),
        ),
        ElevatedButton(
          onPressed: generateError,
          child: const Text('Generate error'),
        ),
      ],
    );
  }

  Future<void> generateError() async {
    Catcher.sendTestException();
  }

  void _changeCustomParameters() {
    final options = catcher.getCurrentConfig()!;
    options.customParameters['Second'] = 'Second parameter';
  }
}
