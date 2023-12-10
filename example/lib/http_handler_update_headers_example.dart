import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  ///Http handler instance
  final httpHandler = HttpHandler(
    HttpRequestType.post,
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    printLogs: true,
    enableStackTrace: false,
    enableApplicationParameters: false,
    enableDeviceParameters: false,
  );

  ///Init catcher
  final debugOptions =
      Catcher2Options(DialogReportMode(), [httpHandler, ConsoleHandler()]);
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  Catcher2(
    rootWidget: const MyApp(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );

  ///At some point of time, you're updating headers:

  httpHandler.headers.clear();
  httpHandler.headers['my_header'] = 'Test';
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
