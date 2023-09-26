import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

late Catcher2 catcher2;

void main() {
  final debugOptions = Catcher2Options(DialogReportMode(), [
    //EmailManualHandler(["recipient@email.com"]),
    HttpHandler(
      HttpRequestType.post,
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      printLogs: true,
    ),
    ConsoleHandler(),
  ]);
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  catcher2 = Catcher2(
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
  Widget build(BuildContext context) => Row(
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

  Future<void> generateError() async {
    Catcher2.sendTestException();
  }

  void changeConfig() {
    catcher2.updateConfig(
      debugConfig: Catcher2Options(
        PageReportMode(),
        [ConsoleHandler()],
      ),
    );
  }
}
