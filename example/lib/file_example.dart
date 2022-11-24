import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  var catcher = Catcher(rootWidget: MyApp(), ensureInitialized: true);
  Directory? externalDir;
  if (Platform.isAndroid || Platform.isIOS) {
    externalDir = await getExternalStorageDirectory();
  }
  if (Platform.isMacOS) {
    externalDir = await getApplicationDocumentsDirectory();
  }
  String path = "";
  if (externalDir != null) {
    path = externalDir.path.toString() + "/log.txt";
  }
  print("PATH: " + path);

  CatcherOptions debugOptions = CatcherOptions(
      DialogReportMode(), [FileHandler(File(path), printLogs: true)]);
  CatcherOptions releaseOptions =
      CatcherOptions(DialogReportMode(), [FileHandler(File(path))]);
  catcher.updateConfig(
      debugConfig: debugOptions, releaseConfig: releaseOptions);
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
      child: Column(
        children: [
          TextButton(
            child: Text("Check permission"),
            onPressed: checkPermissions,
          ),
          TextButton(
            child: Text("Generate error"),
            onPressed: () => generateError(),
          )
        ],
      ),
    );
  }

  void checkPermissions() async {
    var status = await Permission.storage.status;
    print("Status: $status");
    if (!status.isGranted) {
      print("Requested");
    }
  }

  void generateError() async {
    throw "Test exception";
  }
}
