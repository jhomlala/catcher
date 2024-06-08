import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

void main() {
  ///Configure your debug options (settings used in development mode)
  final debugOptions = CatcherOptions(
    ///Show information about caught error in dialog
    DialogReportMode(),
    [
      ///Send logs to HTTP server
      HttpHandler(
        HttpRequestType.post,
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        printLogs: true,
      ),

      ///Print logs in console
      ConsoleHandler(),
    ],
  );

  ///Configure your production options (settings used in release mode)
  final releaseOptions = CatcherOptions(
    ///Show new page with information about caught error
    PageReportMode(),
    [
      ///Send logs to Sentry
      SentryHandler(
        SentryClient(
          SentryOptions(dsn: '<DSN>'),
        ),
      ),

      ///Print logs in console
      ConsoleHandler(),
    ],
  );

  ///Start Catcher and then start App. Now Catcher will guard and report any
  ///error to your configured services!
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
      ///Last step: add navigator key of Catcher here, so Catcher can show
      ///page and dialog!
      navigatorKey: Catcher.navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Catcher example'),
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
    return TextButton(
      onPressed: generateError,
      child: const Text('Generate error'),
    );
  }

  ///Simply just trigger some error.
  Future<void> generateError() async {
    Catcher.sendTestException();
  }
}
