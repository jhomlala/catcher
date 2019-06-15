import 'dart:io';

import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

main() async {
  Directory externalDir = await getExternalStorageDirectory();
  String path = externalDir.path.toString() + "/log.txt";
  print("Path: " + path);

  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [FileHandler(File(path))]);
  CatcherOptions releaseOptions =
      CatcherOptions(DialogReportMode(), [FileHandler(File(path))]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
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
    permission();
    return Container(
        child: FlatButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  permission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    //bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.storage);
  }

  generateError() async {
    throw "Test exception";
  }
}
