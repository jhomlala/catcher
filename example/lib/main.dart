import 'package:flutter/material.dart';
import 'package:catcher/catcher.dart';

void main() => Catcher(MyApp(),
    handlerTimeout: 5000,
    handlers: [ConsoleHandler(), ToastHandler()],
    customParameters: {"application_version": "debug"},
    reportModeType: ReportModeType.silent);

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: FlatButton(
                child: Text("Generate error"),
                onPressed: () => generateError())),
      ),
    );
  }

  generateError() async {
    throw "Test exception";
  }
}
