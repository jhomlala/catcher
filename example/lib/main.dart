import 'package:catcher/handlers/console_handler.dart';
import 'package:flutter/material.dart';

import 'package:catcher/catcher.dart';
void main() => Catcher(application: MyApp(), handlers: [ConsoleHandler()]);
class MyApp extends StatefulWidget{

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
        body: Center(child:
          FlatButton(child: Text("Generate error"),onPressed: () => generateError())
        ),
      ),
    );
  }

  generateError()  async {

    try {
      foo() async {
        throw new StateError('This is an async Dart exception.');
      }
      bar() async {
        await foo();
      }
      await bar();
    } catch (exc,stackTrace){
      print("Cathced exc: "+ exc.toString());
      Catcher.getInstance().reportCheckedError(exc, stackTrace);
    }
  }

}
