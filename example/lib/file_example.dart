import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  final catcher2 = Catcher2(rootWidget: const MyApp(), ensureInitialized: true);
  Directory? externalDir;
  if (Platform.isAndroid || Platform.isIOS) {
    externalDir = await getExternalStorageDirectory();
  }
  if (Platform.isMacOS) {
    externalDir = await getApplicationDocumentsDirectory();
  }
  var path = '';
  if (externalDir != null) {
    path = '${externalDir.path}/log.txt';
  }
  // ignore: avoid_print
  print('PATH: $path');

  final debugOptions = Catcher2Options(
    DialogReportMode(),
    [FileHandler(File(path), printLogs: true)],
  );
  final releaseOptions =
      Catcher2Options(DialogReportMode(), [FileHandler(File(path))]);
  catcher2.updateConfig(
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
  Widget build(BuildContext context) => Column(
        children: [
          TextButton(
            onPressed: checkPermissions,
            child: const Text('Check permission'),
          ),
          TextButton(
            onPressed: generateError,
            child: const Text('Generate error'),
          ),
        ],
      );

  Future<void> checkPermissions() async {
    final status = await Permission.storage.status;
    // ignore: avoid_print
    print('Status: $status');
    if (!status.isGranted) {
      // ignore: avoid_print
      print('Requested');
    }
  }

  Future<void> generateError() async {
    throw Exception('Test exception');
  }
}
