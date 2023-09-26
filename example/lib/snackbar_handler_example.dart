import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(DialogReportMode(), [
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
          // ignore: avoid_print
          print('Click!');
        },
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);
  final releaseOptions = Catcher2Options(DialogReportMode(), [
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

  Catcher2(
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
            title: const Text('Snackbar handler example'),
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
