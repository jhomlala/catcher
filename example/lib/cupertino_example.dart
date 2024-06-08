import 'package:catcher/catcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Catcher(
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
    return CupertinoApp(
      navigatorKey: Catcher.navigatorKey,
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
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.orange,
      child: TextButton(
        onPressed: generateError,
        child: const Text('Generate error'),
      ),
    );
  }

  Future<void> generateError() async {
    Catcher.sendTestException();
  }
}
