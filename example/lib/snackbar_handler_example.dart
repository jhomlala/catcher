import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [
    SnackbarHandler(
      Duration(seconds: 5),
      backgroundColor: Colors.green,
      elevation: 2,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: "Button",
          onPressed: () {
            print("Click!");
          }),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    SnackbarHandler(
      Duration(seconds: 5),
      backgroundColor: Colors.green,
      elevation: 2,
      padding: EdgeInsets.all(16),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);

  Catcher(
      runAppFunction: () {
        runApp(MyApp());
      },
      debugConfig: debugOptions,
      releaseConfig: releaseOptions);
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
          title: const Text('Snackbar handler example'),
        ),
        body: ChildWidget(),
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text("Generate error"),
        onPressed: () => generateError(),
      ),
    );
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}
