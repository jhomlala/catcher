import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(CustomPageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
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

class CustomPageReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    if (context != null) {
      _navigateToPageWidget(report, context);
    }
  }

  Future<void> _navigateToPageWidget(
    Report report,
    BuildContext context,
  ) async {
    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) {
      return;
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => CustomPage(this, report)),
    );
  }

  @override
  bool isContextRequired() => true;

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.web, PlatformType.android, PlatformType.iOS];
}

class CustomPage extends StatelessWidget {
  const CustomPage(this.reportMode, this.report, {super.key});
  final ReportMode reportMode;
  final Report report;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Test'),
        ),
        body: Row(
          children: [
            ElevatedButton(
              child: const Text('Send report'),
              onPressed: () {
                reportMode.onActionConfirmed(report);
              },
            ),
            ElevatedButton(
              child: const Text('Cancel report'),
              onPressed: () {
                reportMode.onActionRejected(report);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
