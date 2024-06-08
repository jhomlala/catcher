import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

late Catcher catcher;

void main() {
  final debugOptions = CatcherOptions(DialogReportMode(), [
    //EmailManualHandler(["recipient@email.com"]),
    HttpHandler(
      HttpRequestType.post,
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      printLogs: true,
    ),
    ConsoleHandler(),
  ]);
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
    return Row(
      children: [
        TextButton(
          onPressed: changeConfig,
          child: const Text('Change config'),
        ),
        TextButton(
          onPressed: generateError,
          child: const Text('Generate error'),
        ),
      ],
    );
  }

  Future<void> generateError() async {
    Catcher.sendTestException();
  }

  void changeConfig() {
    catcher.updateConfig(
      debugConfig: CatcherOptions(
        PageReportMode(),
        [ConsoleHandler()],
      ),
    );
  }
}
