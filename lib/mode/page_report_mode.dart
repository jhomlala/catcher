import 'package:catcher/catcher.dart';
import 'package:catcher/mode/report_mode.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageReportMode extends ReportMode {
  final ReportModeAction reportModeAction;
  PageReportMode(this.reportModeAction) : super(reportModeAction);

  @override
  void requestAction(Report report, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageWidget(reportModeAction,report)),
    );
  }
}

class PageWidget extends StatefulWidget {
  final ReportModeAction reportModeAction;
  final Report report;

  PageWidget(this.reportModeAction, this.report);

  @override
  PageWidgetState createState() {
    return new PageWidgetState();
  }
}

class PageWidgetState extends State<PageWidget> {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    var items = getStackTrace();
    _context = context;
    return Scaffold(
        appBar: AppBar(title: Text("Crash handler"),), body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            Text("Crash", style: _getTextStyle(45)),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
                "Unexepcted error occured in application. We have created report which can be send it by you to developers. Please click accept to send error report.",
                style: _getTextStyle(15)),
            Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              height: 400.0,
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),

                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text('${items[index]}', style: _getTextStyle(10),);
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              FlatButton(child: Text("Accept"), onPressed: () => _acceptReport(),),
              FlatButton(child: Text("Cancel"), onPressed: () => _cancelReport(),),
            ],)
          ],
        )));
  }

  TextStyle _getTextStyle(double fontSize) {
    return TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        decoration: TextDecoration.none);
  }

  List<String> getStackTrace() {
    return widget.report.stackTrace.toString().split("\n");
  }

  _acceptReport() {
    widget.reportModeAction.onActionConfirmed();
    _closePage();
  }

  _cancelReport() {
    widget.reportModeAction.onActionRejected();
    _closePage();
  }

  _closePage() {
    Navigator.of(_context).pop();
  }
}
