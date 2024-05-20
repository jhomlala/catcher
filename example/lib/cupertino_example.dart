import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => CupertinoApp(
        navigatorKey: Catcher2.navigatorKey,
        home: const CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Cupertino example'),
          ),
          child: SafeArea(
            child: ChildWidget(),
          ),
        ),
      );
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.orange,
        child: TextButton(
          onPressed: generateError,
          child: const Text('Generate error'),
        ),
      );

  Future<void> generateError() async {
    Catcher2.sendTestException();
  }
}
