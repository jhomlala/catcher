import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  _showDialog(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(localizationOptions.dialogReportModeTitle),
            content: Text(localizationOptions.dialogReportModeDescription),
            actions: <Widget>[
              FlatButton(
                child: Text(localizationOptions.dialogReportModeAccept),
                onPressed: () => _acceptReport(context, report),
              ),
              FlatButton(
                child: Text(localizationOptions.dialogReportModeCancel),
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
