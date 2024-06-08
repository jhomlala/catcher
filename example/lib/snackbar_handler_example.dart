import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = CatcherOptions(DialogReportMode(), [
    SnackbarHandler(
      const Duration(seconds: 5),
      backgroundColor: Colors.green,
      elevation: 2,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Button',
        onPressed: () {
          print('Click!');
        },
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);
  final releaseOptions = CatcherOptions(DialogReportMode(), [
    SnackbarHandler(
      const Duration(seconds: 5),
      backgroundColor: Colors.green,
      elevation: 2,
      padding: const EdgeInsets.all(16),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);

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
      navigatorKey: Catcher.navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Snackbar handler example'),
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
