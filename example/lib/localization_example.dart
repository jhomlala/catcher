import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    ConsoleHandler(),
    HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
        printLogs: true)
  ], localizationOptions: [
    LocalizationOptions(
      "en",
      dialogReportModeTitle: "Custom message",
      dialogReportModeDescription: "Custom message",
      dialogReportModeAccept: "YES",
      dialogReportModeCancel: "NO",
    ),
    LocalizationOptions("pl",
        notificationReportModeTitle: "Wystąpił błąd aplikacji",
        notificationReportModeContent:
            "Naciśnij tutaj aby wysłać raport do zespołu wpsarcia",
        dialogReportModeTitle: "Błąd aplikacji",
        dialogReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        dialogReportModeAccept: "Akceptuj",
        dialogReportModeCancel: "Odrzuć",
        pageReportModeTitle: "Błąd aplikacji",
        pageReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        pageReportModeAccept: "Akceptuj",
        pageReportModeCancel: "Odrzuć")
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(
      rootWidget: MyApp(),
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
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

  void generateError() async {
    throw "Test exception";
  }
}
