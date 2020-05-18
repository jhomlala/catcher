import 'dart:io';

import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  ///After Flutter 1.17.0 update ensureInitialized causes to not catching errors by Catcher...
  //WidgetsFlutterBinding.ensureInitialized();
  //Directory externalDir = await getExternalStorageDirectory();
  //String path = externalDir.path.toString() + "/log.txt";
  ///We need to specify path manually
  String path = "/storage/emulated/0/log.txt";
  CatcherOptions debugOptions = CatcherOptions(
      DialogReportMode(), [FileHandler(File(path), printLogs: true)]);
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
    return Container(
      child: Column(
        children: [
          FlatButton(
            child: Text("Check permission"),
            onPressed:  checkPermissions,
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
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    bool isShown = await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.storage);
  }

  generateError() async {
    throw "Test exception";
  }
}
