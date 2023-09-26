import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';

void main() {
  final debugOptions = Catcher2Options(
    DialogReportMode(),
    [
      EmailManualHandler(
        ['email1@email.com', 'email2@email.com'],
        enableDeviceParameters: true,
        enableStackTrace: true,
        enableCustomParameters: true,
        enableApplicationParameters: true,
        sendHtml: true,
        emailTitle: 'Sample Title',
        emailHeader: 'Sample Header',
        printLogs: true,
      ),
    ],
    customParameters: <String, dynamic>{
      'Test': 'Test12345',
      'Test2': 'Test54321',
    },
  );

  Catcher2(
    rootWidget: const MyApp(),
    debugConfig: debugOptions,
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
    throw Exception('Test exception');
  }
}
