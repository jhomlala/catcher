import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  final String titleText;
  final String descriptionText;
  final String acceptText;
  final String cancelText;

  DialogReportMode(
      {this.titleText = "Crash",
      this.descriptionText = "Unexepcted error occured in application. "
          "We have created report which can be send it by you to developers. "
          "Please click accept to send error report.",
      this.acceptText = "Accept",
      this.cancelText = "Cancel"});

  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  _showDialog(Report report, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(descriptionText),
            actions: <Widget>[
              FlatButton(
                child: Text(acceptText),
                onPressed: () => _acceptReport(context, report),
              ),
              FlatButton(
                child: Text(cancelText),
                onPressed: () => _cancelReport(context, report),
              ),
            ],
          );
        });
  }

  _acceptReport(BuildContext context, Report report) {
    super.onActionConfirmed(report);
    Navigator.pop(context);
  }

  _cancelReport(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }
}
