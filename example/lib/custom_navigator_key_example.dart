import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(['recipient@email.com']),
    ConsoleHandler(),
  ]);
  final releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  final navigatorKey = GlobalKey<NavigatorState>();
  Catcher(
    rootWidget: MyApp(navigatorKey),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
    navigatorKey: navigatorKey,
  );
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp(this.navigatorKey, {super.key});

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
      navigatorKey: widget.navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
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

  Future<void> generateError() async {
    Catcher.sendTestException();
  }
}
