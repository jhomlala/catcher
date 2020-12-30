import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  var catcher = Catcher(MyApp(), ensureInitialized: true);
  Directory externalDir = await getExternalStorageDirectory();
  String path = externalDir.path.toString() + "/log.txt";

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
          FlatButton(
            child: Text("Check permission"),
            onPressed: checkPermissions,
          ),
          FlatButton(
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
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      print("Requested");
    }
  }

  generateError() async {
    throw "Test exception";
  }
}
