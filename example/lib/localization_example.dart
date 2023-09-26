import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
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
    localizationOptions: [
      LocalizationOptions(
        'en',
        dialogReportModeTitle: 'Custom message',
        dialogReportModeDescription: 'Custom message',
        dialogReportModeAccept: 'YES',
        dialogReportModeCancel: 'NO',
      ),
      LocalizationOptions(
        'pl',
        notificationReportModeTitle: 'Wystąpił błąd aplikacji',
        notificationReportModeContent:
            'Naciśnij tutaj aby wysłać raport do zespołu wpsarcia',
        dialogReportModeTitle: 'Błąd aplikacji',
        dialogReportModeDescription:
            'Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest '
            'gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby '
            'wysłać raport lub odrzuć aby odrzucić raport.',
        dialogReportModeAccept: 'Akceptuj',
        dialogReportModeCancel: 'Odrzuć',
        pageReportModeTitle: 'Błąd aplikacji',
        pageReportModeDescription:
            'Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest '
            'gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby '
            'wysłać raport lub odrzuć aby odrzucić raport.',
        pageReportModeAccept: 'Akceptuj',
        pageReportModeCancel: 'Odrzuć',
      ),
    ],
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('pl', 'PL'),
        ],
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
    throw Exception('Test exception');
  }
}
