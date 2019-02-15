import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
    HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
        printLogs: true)
  ], localizationOptions: [
    LocalizationOptions.buildDefaultPolishOptions()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(NotificationReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pl', 'PL'),
      ],
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlatButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  generateError() async {
    throw "Test exception";
  }
}
