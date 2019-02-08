import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

void main() => Catcher(MyApp(),
    handlerTimeout: 5000,
    handlers: [ConsoleHandler(), EmailManualHandler(["jhomlala@gmail.com"])],
    customParameters: {"application_version": "debug"},
    reportMode: DialogReportMode());

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
          body: ChildWidget()
      ),
    );
  }
}



class ChildWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(child:  FlatButton(
        child: Text("Generate error"),
        onPressed: () => generateError()));
  }

  generateError() async {
    throw "Test exception";
  }

}

