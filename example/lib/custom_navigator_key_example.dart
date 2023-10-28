import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(DialogReportMode(), [
    EmailManualHandler(['recipient@email.com']),
    ConsoleHandler(),
  ]);
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  final navigatorKey = GlobalKey<NavigatorState>();
  Catcher2(
    rootWidget: MyApp(navigatorKey),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
    navigatorKey: navigatorKey,
  );
}

class MyApp extends StatefulWidget {
  const MyApp(this.navigatorKey, {super.key});

  final GlobalKey<NavigatorState> navigatorKey;

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
        navigatorKey: widget.navigatorKey,
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
