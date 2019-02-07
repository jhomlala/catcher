import 'package:catcher/mode/report_mode.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class DialogReportMode extends ReportMode {
  DialogReportMode(ReportModeAction reportModeAction) : super(reportModeAction);

  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  _showDialog(Report report, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
              title: Text("Crash"),
              actions: <Widget>[
                FlatButton(child: Text("Accept"), onPressed: () => _acceptReport(context),),
                FlatButton(child: Text("Cancel"), onPressed: () => _cancelReport(context),),
              ],
              content: Text(
                  "Unexepcted error occured in application. We have created report which can be send it by you to developers. Please click accept to send error report."));
        });
  }

  _acceptReport(BuildContext context) {
    reportModeAction.onActionConfirmed();
    Navigator.pop(context);
  }

  _cancelReport(BuildContext context) {
    reportModeAction.onActionRejected();
    Navigator.pop(context);
  }
}
